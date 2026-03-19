#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import os
import sys
import uuid
from datetime import datetime, timezone
from pathlib import Path


DEFAULT_STORAGE_DIR = Path("reports/comparison/round-metrics")
DEFAULT_SESSIONS_DIR = Path.home() / ".codex" / "sessions"
TOKEN_FIELDS = (
    "input_tokens",
    "cached_input_tokens",
    "output_tokens",
    "reasoning_output_tokens",
    "total_tokens",
)


def now_utc() -> datetime:
    return datetime.now(timezone.utc).replace(microsecond=0)


def to_iso(dt: datetime) -> str:
    return dt.isoformat().replace("+00:00", "Z")


def parse_iso(value: str) -> datetime:
    if value.endswith("Z"):
        value = value[:-1] + "+00:00"
    return datetime.fromisoformat(value)


def duration_seconds(started_at: str, ended_at: str) -> int:
    start = parse_iso(started_at)
    end = parse_iso(ended_at)
    return max(0, int((end - start).total_seconds()))


def ensure_parent(path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)


def load_jsonl(path: Path):
    with path.open() as handle:
        for line in handle:
            line = line.strip()
            if not line:
                continue
            try:
                yield json.loads(line)
            except json.JSONDecodeError:
                continue


def load_round(path: Path) -> dict:
    try:
        return json.loads(path.read_text())
    except FileNotFoundError:
        raise SystemExit(f"round file not found: {path}")


def save_round(path: Path, payload: dict) -> None:
    ensure_parent(path)
    path.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")


def active_step_index(payload: dict) -> int | None:
    for index, step in enumerate(payload.get("steps", [])):
        if step.get("ended_at") is None:
            return index
    return None


def format_duration(seconds: int | None) -> str:
    if seconds is None:
        return "not finished"
    hours, remainder = divmod(seconds, 3600)
    minutes, secs = divmod(remainder, 60)
    if hours:
        return f"{hours}h {minutes}m {secs}s"
    if minutes:
        return f"{minutes}m {secs}s"
    return f"{secs}s"


def format_token_consumption(value) -> str:
    if value is None:
        return "not recorded"
    if isinstance(value, str):
        return value
    if isinstance(value, dict):
        if "total_tokens" in value:
            return (
                f"total={value['total_tokens']}, "
                f"input={value['input_tokens']}, "
                f"cached_input={value['cached_input_tokens']}, "
                f"output={value['output_tokens']}, "
                f"reasoning_output={value['reasoning_output_tokens']}"
            )
        if "delta" in value:
            return format_token_consumption(value["delta"])
    return str(value)


def compute_step_rows(payload: dict) -> list[tuple[str, str]]:
    rows = []
    for step in payload.get("steps", []):
        rows.append((step["name"], format_duration(step.get("duration_sec"))))
    return rows


def normalize_usage(usage: dict | None) -> dict | None:
    if usage is None:
        return None
    normalized = {}
    for key in TOKEN_FIELDS:
        normalized[key] = int(usage.get(key, 0))
    return normalized


def subtract_usage(end_usage: dict | None, start_usage: dict | None) -> dict | None:
    if end_usage is None or start_usage is None:
        return None
    return {
        key: max(0, int(end_usage.get(key, 0)) - int(start_usage.get(key, 0)))
        for key in TOKEN_FIELDS
    }


def resolve_thread_id(args: argparse.Namespace) -> str | None:
    return getattr(args, "thread_id", None) or os.environ.get("CODEX_THREAD_ID")


def locate_session_file(
    *, thread_id: str | None, session_file: str | None, sessions_root: str | None
) -> Path | None:
    if session_file:
        path = Path(session_file)
        return path if path.exists() else None
    if not thread_id:
        return None
    root = Path(sessions_root) if sessions_root else DEFAULT_SESSIONS_DIR
    matches = sorted(root.glob(f"**/rollout-*{thread_id}.jsonl"), key=lambda path: path.stat().st_mtime, reverse=True)
    return matches[0] if matches else None


def token_snapshot_at_or_before(session_file: Path, *, cutoff: str) -> dict | None:
    cutoff_dt = parse_iso(cutoff)
    latest = None
    for event in load_jsonl(session_file):
        if event.get("type") != "event_msg":
            continue
        payload = event.get("payload") or {}
        if payload.get("type") != "token_count":
            continue
        try:
            timestamp = parse_iso(event["timestamp"])
        except (KeyError, ValueError, TypeError):
            continue
        if timestamp > cutoff_dt:
            continue
        info = payload.get("info") or {}
        total_usage = normalize_usage(info.get("total_token_usage"))
        last_usage = normalize_usage(info.get("last_token_usage"))
        if total_usage is None or last_usage is None:
            continue
        latest = {
            "timestamp": event["timestamp"],
            "total": total_usage,
            "last": last_usage,
            "model_context_window": info.get("model_context_window"),
        }
    return latest


def resolve_token_measurement(
    *,
    started_at: str,
    ended_at: str,
    payload: dict,
    thread_id: str | None,
    session_file: str | None,
    sessions_root: str | None,
) -> tuple[str | dict, str | None, str | None, dict | None, dict | None, dict | None]:
    resolved_thread_id = thread_id or payload.get("codex_thread_id")
    resolved_session_file = locate_session_file(
        thread_id=resolved_thread_id,
        session_file=session_file or payload.get("codex_session_file"),
        sessions_root=sessions_root,
    )
    if resolved_session_file is None:
        return "not observable", resolved_thread_id, None, None, None, None
    start_snapshot = token_snapshot_at_or_before(resolved_session_file, cutoff=started_at)
    end_snapshot = token_snapshot_at_or_before(resolved_session_file, cutoff=ended_at)
    if start_snapshot is None or end_snapshot is None:
        return "not observable", resolved_thread_id, str(resolved_session_file), start_snapshot, end_snapshot, None
    delta = subtract_usage(end_snapshot["total"], start_snapshot["total"])
    if delta is None:
        return "not observable", resolved_thread_id, str(resolved_session_file), start_snapshot, end_snapshot, None
    return delta, resolved_thread_id, str(resolved_session_file), start_snapshot, end_snapshot, delta


def cmd_start_round(args: argparse.Namespace) -> int:
    started_at = to_iso(now_utc())
    round_id = args.round_id or (
        f"{datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ')}-"
        f"{args.framework_lane}-{args.work_item_type}-{uuid.uuid4().hex[:8]}"
    )
    storage_dir = Path(args.storage_dir or DEFAULT_STORAGE_DIR)
    round_file = storage_dir / f"{round_id}.json"
    payload = {
        "version": 1,
        "round_id": round_id,
        "framework_lane": args.framework_lane,
        "work_item_type": args.work_item_type,
        "work_item_ref": args.work_item_ref,
        "codex_thread_id": resolve_thread_id(args),
        "codex_session_file": None,
        "started_at": started_at,
        "ended_at": None,
        "total_duration_sec": None,
        "working_effort_summary": None,
        "token_consumption": None,
        "token_usage_start": None,
        "token_usage_end": None,
        "token_usage_delta": None,
        "token_usage_source": None,
        "steps": [],
    }
    session_file = locate_session_file(
        thread_id=payload["codex_thread_id"],
        session_file=getattr(args, "session_file", None),
        sessions_root=getattr(args, "sessions_root", None),
    )
    if session_file is not None:
        payload["codex_session_file"] = str(session_file)
        payload["token_usage_source"] = "codex-session-jsonl"
    save_round(round_file, payload)
    print(json.dumps({"round_file": str(round_file), "round_id": round_id, "started_at": started_at}))
    return 0


def cmd_start_step(args: argparse.Namespace) -> int:
    round_file = Path(args.round_file)
    payload = load_round(round_file)
    if payload.get("ended_at") is not None:
        raise SystemExit("cannot start a step on a finished round")
    if active_step_index(payload) is not None:
        raise SystemExit("an active step already exists; end it before starting another step")
    payload["steps"].append(
        {
            "name": args.step_name,
            "started_at": to_iso(now_utc()),
            "ended_at": None,
            "duration_sec": None,
        }
    )
    save_round(round_file, payload)
    print(json.dumps({"round_file": str(round_file), "step_name": args.step_name, "status": "started"}))
    return 0


def cmd_end_step(args: argparse.Namespace) -> int:
    round_file = Path(args.round_file)
    payload = load_round(round_file)
    index = active_step_index(payload)
    if index is None:
        raise SystemExit("no active step to end")
    step = payload["steps"][index]
    if args.step_name and step["name"] != args.step_name:
        raise SystemExit(
            f"active step is '{step['name']}', which does not match requested step '{args.step_name}'"
        )
    step["ended_at"] = to_iso(now_utc())
    step["duration_sec"] = duration_seconds(step["started_at"], step["ended_at"])
    save_round(round_file, payload)
    print(
        json.dumps(
            {
                "round_file": str(round_file),
                "step_name": step["name"],
                "status": "ended",
                "duration_sec": step["duration_sec"],
            }
        )
    )
    return 0


def cmd_end_round(args: argparse.Namespace) -> int:
    round_file = Path(args.round_file)
    payload = load_round(round_file)
    if payload.get("ended_at") is not None:
        raise SystemExit("round is already finished")
    if active_step_index(payload) is not None:
        raise SystemExit("cannot finish round while an internal step is still active")
    ended_at = to_iso(now_utc())
    payload["ended_at"] = ended_at
    payload["total_duration_sec"] = duration_seconds(payload["started_at"], ended_at)
    payload["working_effort_summary"] = args.effort_summary
    measured_token_consumption, resolved_thread_id, resolved_session_file, start_snapshot, end_snapshot, delta = (
        resolve_token_measurement(
            started_at=payload["started_at"],
            ended_at=ended_at,
            payload=payload,
            thread_id=resolve_thread_id(args),
            session_file=getattr(args, "session_file", None),
            sessions_root=getattr(args, "sessions_root", None),
        )
    )
    payload["codex_thread_id"] = resolved_thread_id
    payload["codex_session_file"] = resolved_session_file
    payload["token_usage_start"] = start_snapshot
    payload["token_usage_end"] = end_snapshot
    payload["token_usage_delta"] = delta
    if resolved_session_file is not None:
        payload["token_usage_source"] = "codex-session-jsonl"
    payload["token_consumption"] = args.token_consumption or measured_token_consumption
    save_round(round_file, payload)
    print(
        json.dumps(
            {
                "round_file": str(round_file),
                "status": "finished",
                "total_duration_sec": payload["total_duration_sec"],
                "token_consumption": format_token_consumption(payload["token_consumption"]),
            }
        )
    )
    return 0


def markdown_summary(payload: dict) -> str:
    lines = [
        f"framework lane: {payload['framework_lane']}",
        f"work item type: {payload['work_item_type']}",
        f"work item ref: {payload['work_item_ref']}",
        f"working effort summary: {payload.get('working_effort_summary') or 'not recorded'}",
        f"started at: {payload['started_at']}",
        f"ended at: {payload.get('ended_at') or 'not finished'}",
        f"total duration: {format_duration(payload.get('total_duration_sec'))}",
        f"token consumption: {format_token_consumption(payload.get('token_consumption'))}",
        "internal step duration:",
    ]
    rows = compute_step_rows(payload)
    if rows:
        for name, duration in rows:
            lines.append(f"- {name}: {duration}")
    else:
        lines.append("- none recorded")
    return "\n".join(lines)


def cmd_summary(args: argparse.Namespace) -> int:
    payload = load_round(Path(args.round_file))
    if args.format == "json":
        print(json.dumps(payload, indent=2, sort_keys=True))
        return 0
    print(markdown_summary(payload))
    return 0


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="Record delivery round timing and summary data.")
    subparsers = parser.add_subparsers(dest="command", required=True)

    start_round = subparsers.add_parser("start-round")
    start_round.add_argument("--framework-lane", required=True)
    start_round.add_argument("--work-item-type", required=True, choices=["requirement", "review-fix", "bug-fix"])
    start_round.add_argument("--work-item-ref", required=True)
    start_round.add_argument("--round-id")
    start_round.add_argument("--storage-dir")
    start_round.add_argument("--thread-id")
    start_round.add_argument("--session-file")
    start_round.add_argument("--sessions-root")
    start_round.set_defaults(func=cmd_start_round)

    start_step = subparsers.add_parser("start-step")
    start_step.add_argument("--round-file", required=True)
    start_step.add_argument("--step-name", required=True)
    start_step.set_defaults(func=cmd_start_step)

    end_step = subparsers.add_parser("end-step")
    end_step.add_argument("--round-file", required=True)
    end_step.add_argument("--step-name")
    end_step.set_defaults(func=cmd_end_step)

    end_round = subparsers.add_parser("end-round")
    end_round.add_argument("--round-file", required=True)
    end_round.add_argument("--effort-summary", required=True)
    end_round.add_argument("--token-consumption")
    end_round.add_argument("--thread-id")
    end_round.add_argument("--session-file")
    end_round.add_argument("--sessions-root")
    end_round.set_defaults(func=cmd_end_round)

    summary = subparsers.add_parser("summary")
    summary.add_argument("--round-file", required=True)
    summary.add_argument("--format", choices=["markdown", "json"], default="markdown")
    summary.set_defaults(func=cmd_summary)

    return parser


def main() -> int:
    parser = build_parser()
    args = parser.parse_args()
    return args.func(args)


if __name__ == "__main__":
    sys.exit(main())
