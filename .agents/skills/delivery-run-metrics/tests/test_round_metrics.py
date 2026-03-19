import argparse
import io
import importlib.util
import json
import tempfile
import unittest
from contextlib import redirect_stdout
from datetime import datetime, timezone
from pathlib import Path
from unittest import mock


SCRIPT_PATH = (
    Path(__file__).resolve().parents[1] / "scripts" / "round_metrics.py"
)
SPEC = importlib.util.spec_from_file_location("round_metrics", SCRIPT_PATH)
round_metrics = importlib.util.module_from_spec(SPEC)
assert SPEC.loader is not None
SPEC.loader.exec_module(round_metrics)


def dt(value: str) -> datetime:
    return datetime.fromisoformat(value.replace("Z", "+00:00")).astimezone(timezone.utc)


class RoundMetricsTest(unittest.TestCase):
    def setUp(self) -> None:
        self.temp_dir = tempfile.TemporaryDirectory()
        self.storage_dir = Path(self.temp_dir.name)
        self.env_patcher = mock.patch.dict(round_metrics.os.environ, {"CODEX_THREAD_ID": ""}, clear=False)
        self.env_patcher.start()

    def tearDown(self) -> None:
        self.env_patcher.stop()
        self.temp_dir.cleanup()

    def start_round(self, time_value: datetime, **overrides) -> Path:
        payload = dict(
            framework_lane="cjmp",
            work_item_type="requirement",
            work_item_ref="issue-12",
            round_id="round-1",
            storage_dir=str(self.storage_dir),
            thread_id=None,
            session_file=None,
            sessions_root=None,
        )
        payload.update(overrides)
        args = argparse.Namespace(**payload)
        with mock.patch.object(round_metrics, "now_utc", return_value=time_value):
            rc, _ = self.run_command(round_metrics.cmd_start_round, args)
        self.assertEqual(rc, 0)
        return self.storage_dir / "round-1.json"

    def load_round(self, round_file: Path) -> dict:
        return json.loads(round_file.read_text())

    def run_command(self, func, args):
        output = io.StringIO()
        with redirect_stdout(output):
            rc = func(args)
        return rc, output.getvalue()

    def test_round_lifecycle_computes_exact_step_and_total_durations(self) -> None:
        round_file = self.start_round(dt("2026-03-19T08:00:00Z"))

        with mock.patch.object(round_metrics, "now_utc", return_value=dt("2026-03-19T08:00:05Z")):
            rc, _ = self.run_command(round_metrics.cmd_start_step,
                argparse.Namespace(round_file=str(round_file), step_name="implementation")
            )
        self.assertEqual(rc, 0)

        with mock.patch.object(round_metrics, "now_utc", return_value=dt("2026-03-19T08:00:45Z")):
            rc, _ = self.run_command(round_metrics.cmd_end_step,
                argparse.Namespace(round_file=str(round_file), step_name="implementation")
            )
        self.assertEqual(rc, 0)

        with mock.patch.object(round_metrics, "now_utc", return_value=dt("2026-03-19T08:01:30Z")):
            rc, _ = self.run_command(round_metrics.cmd_end_round,
                argparse.Namespace(
                    round_file=str(round_file),
                    effort_summary="implemented chat list slice",
                    token_consumption="1234",
                )
            )
        self.assertEqual(rc, 0)

        payload = self.load_round(round_file)
        self.assertEqual(payload["framework_lane"], "cjmp")
        self.assertEqual(payload["work_item_type"], "requirement")
        self.assertEqual(payload["work_item_ref"], "issue-12")
        self.assertEqual(payload["started_at"], "2026-03-19T08:00:00Z")
        self.assertEqual(payload["ended_at"], "2026-03-19T08:01:30Z")
        self.assertEqual(payload["total_duration_sec"], 90)
        self.assertEqual(payload["working_effort_summary"], "implemented chat list slice")
        self.assertEqual(payload["token_consumption"], "1234")
        self.assertEqual(len(payload["steps"]), 1)
        self.assertEqual(payload["steps"][0]["name"], "implementation")
        self.assertEqual(payload["steps"][0]["duration_sec"], 40)

    def test_cannot_start_second_step_while_first_step_is_active(self) -> None:
        round_file = self.start_round(dt("2026-03-19T08:00:00Z"))

        with mock.patch.object(round_metrics, "now_utc", return_value=dt("2026-03-19T08:00:05Z")):
            self.run_command(round_metrics.cmd_start_step,
                argparse.Namespace(round_file=str(round_file), step_name="implementation")
            )

        with self.assertRaises(SystemExit) as ctx:
            round_metrics.cmd_start_step(
                argparse.Namespace(round_file=str(round_file), step_name="testing")
            )
        self.assertIn("active step already exists", str(ctx.exception))

    def test_cannot_finish_round_with_active_step(self) -> None:
        round_file = self.start_round(dt("2026-03-19T08:00:00Z"))

        with mock.patch.object(round_metrics, "now_utc", return_value=dt("2026-03-19T08:00:05Z")):
            self.run_command(round_metrics.cmd_start_step,
                argparse.Namespace(round_file=str(round_file), step_name="implementation")
            )

        with self.assertRaises(SystemExit) as ctx:
            round_metrics.cmd_end_round(
                argparse.Namespace(
                    round_file=str(round_file),
                    effort_summary="implemented chat list slice",
                    token_consumption="not observable",
                )
            )
        self.assertIn("cannot finish round while an internal step is still active", str(ctx.exception))

    def test_markdown_summary_contains_required_fields(self) -> None:
        round_file = self.start_round(dt("2026-03-19T08:00:00Z"))

        with mock.patch.object(round_metrics, "now_utc", return_value=dt("2026-03-19T08:00:10Z")):
            self.run_command(round_metrics.cmd_end_round,
                argparse.Namespace(
                    round_file=str(round_file),
                    effort_summary="reviewed acceptance gap",
                    token_consumption="not observable",
                )
            )

        payload = self.load_round(round_file)
        summary = round_metrics.markdown_summary(payload)
        self.assertIn("framework lane: cjmp", summary)
        self.assertIn("work item type: requirement", summary)
        self.assertIn("work item ref: issue-12", summary)
        self.assertIn("working effort summary: reviewed acceptance gap", summary)
        self.assertIn("total duration: 10s", summary)
        self.assertIn("token consumption: not observable", summary)
        self.assertIn("internal step duration:", summary)

    def test_token_consumption_is_auto_measured_from_session_log(self) -> None:
        session_file = self.storage_dir / "rollout-2026-03-19T08-00-00-test-thread.jsonl"
        session_file.write_text(
            "\n".join(
                [
                    json.dumps(
                        {
                            "timestamp": "2026-03-19T08:00:00Z",
                            "type": "event_msg",
                            "payload": {
                                "type": "token_count",
                                "info": {
                                    "total_token_usage": {
                                        "input_tokens": 1000,
                                        "cached_input_tokens": 200,
                                        "output_tokens": 40,
                                        "reasoning_output_tokens": 10,
                                        "total_tokens": 1040,
                                    },
                                    "last_token_usage": {
                                        "input_tokens": 1000,
                                        "cached_input_tokens": 200,
                                        "output_tokens": 40,
                                        "reasoning_output_tokens": 10,
                                        "total_tokens": 1040,
                                    },
                                    "model_context_window": 258400,
                                },
                            },
                        }
                    ),
                    json.dumps(
                        {
                            "timestamp": "2026-03-19T08:01:30Z",
                            "type": "event_msg",
                            "payload": {
                                "type": "token_count",
                                "info": {
                                    "total_token_usage": {
                                        "input_tokens": 1450,
                                        "cached_input_tokens": 260,
                                        "output_tokens": 95,
                                        "reasoning_output_tokens": 25,
                                        "total_tokens": 1545,
                                    },
                                    "last_token_usage": {
                                        "input_tokens": 450,
                                        "cached_input_tokens": 60,
                                        "output_tokens": 55,
                                        "reasoning_output_tokens": 15,
                                        "total_tokens": 505,
                                    },
                                    "model_context_window": 258400,
                                },
                            },
                        }
                    ),
                ]
            )
            + "\n"
        )

        round_file = self.start_round(
            dt("2026-03-19T08:00:05Z"),
            thread_id="test-thread",
            session_file=str(session_file),
        )

        with mock.patch.object(round_metrics, "now_utc", return_value=dt("2026-03-19T08:01:30Z")):
            self.run_command(
                round_metrics.cmd_end_round,
                argparse.Namespace(
                    round_file=str(round_file),
                    effort_summary="implemented chat list slice",
                    token_consumption=None,
                    thread_id="test-thread",
                    session_file=str(session_file),
                    sessions_root=None,
                ),
            )

        payload = self.load_round(round_file)
        self.assertEqual(
            payload["token_usage_delta"],
            {
                "input_tokens": 450,
                "cached_input_tokens": 60,
                "output_tokens": 55,
                "reasoning_output_tokens": 15,
                "total_tokens": 505,
            },
        )
        self.assertEqual(payload["token_consumption"]["total_tokens"], 505)
        summary = round_metrics.markdown_summary(payload)
        self.assertIn("token consumption: total=505, input=450, cached_input=60, output=55, reasoning_output=15", summary)


if __name__ == "__main__":
    unittest.main()
