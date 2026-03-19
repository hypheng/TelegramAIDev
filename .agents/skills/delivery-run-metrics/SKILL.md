---
name: delivery-run-metrics
description: Use when a delivery round starts, when each internal step starts or ends, and when the round finishes, so durations are recorded accurately and the current-round summary can be written to a framework-specific comparison round log under reports/comparison.
---

# Delivery Run Metrics

Record the measurable cost of the current delivery round in a durable, framework-comparable way.

Use `scripts/round_metrics.py` for timestamp capture and duration calculation. Do not hand-calculate durations when the script can record them live.

## Use this skill when

- a `requirement` implementation round starts
- a PR review-fix round starts
- a `bug` fix round starts
- an internal step starts
- an internal step ends
- the delivery round finishes
- you need a durable summary for `CJMP`, `KMP`, or `flutter`

## Workflow

1. At the start of the round, create the round record with `start-round`.
   - Identify the current round type:
     - `requirement`
     - `review-fix`
     - `bug-fix`
   - Record the framework lane and work item reference.
2. At the beginning of each internal step, call `start-step`.
3. At the end of each internal step, call `end-step`.
4. At the end of the round, call `end-round`.
   - Record a concise working effort summary:
     - what changed
     - why this round was needed
     - what was validated in this round
   - Let the script auto-measure token consumption from the current Codex session when available.
   - Use `--token-consumption` only as a fallback override when automatic measurement is unavailable.
5. Generate the durable current-round summary with `summary`.
6. Write or update the relevant framework-specific round log under `reports/comparison/`.
   - Keep the output framework-specific and comparable with the other lanes.
   - Do not append every round directly into the aggregate overview or final comparison report.
   - Use the aggregate overview only for deliberate rollups or synthesized comparisons across multiple rounds.
   - Do not overwrite unrelated framework data.

## Commands

Use these commands from the skill directory:

```bash
python3 scripts/round_metrics.py start-round --framework-lane cjmp --work-item-type requirement --work-item-ref issue-12
python3 scripts/round_metrics.py start-step --round-file <round-file> --step-name implementation
python3 scripts/round_metrics.py end-step --round-file <round-file> --step-name implementation
python3 scripts/round_metrics.py end-round --round-file <round-file> --effort-summary "implemented chat list slice"
python3 scripts/round_metrics.py summary --round-file <round-file> --format markdown
```

Optional fallback when automatic token measurement is unavailable:

```bash
python3 scripts/round_metrics.py end-round --round-file <round-file> --effort-summary "implemented chat list slice" --token-consumption "not observable"
```

## Output requirements

The round summary should contain:

- framework lane
- work item type
- work item reference
- working effort summary
- total duration
- internal step duration
- token consumption or `not observable`

## Storage

- Raw round records are stored as JSON under `reports/comparison/round-metrics/` by default.
- In Codex runs, token consumption is auto-derived from the current session log by using `CODEX_THREAD_ID` and `~/.codex/sessions/`.
- Use `--storage-dir` only when you have a good reason to store the records somewhere else.

## Quality bar

- Record timestamps live at round start and step boundaries.
- Start the round as soon as the delivery round actually begins, so the token baseline is taken from the closest available Codex snapshot.
- Prefer exact timings over rough estimates.
- Keep step names short and concrete.
- Make the summary comparable across frameworks.
- If measurement quality is weak, say so explicitly instead of pretending precision.
