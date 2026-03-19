---
name: ai-efficiency-friction-check
description: Use when a delivery or acceptance round finishes and you need to check whether the round exposed confirmed CJMP friction or repo-level AI delivery friction, summarize the evidence, and decide whether to create an ai-efficiency issue and durable notes.
---

# AI Efficiency Friction Check

Evaluate whether the current round exposed a real AI delivery or acceptance efficiency problem worth tracking.

## Use this skill when

- a `requirement` implementation round finishes
- a `bug` fix round finishes
- a `requirement` acceptance round finishes
- a `bug` re-validation round finishes
- a delivery round felt inefficient and you need to decide whether that friction is real
- an acceptance round felt inefficient, blocked, or weakly evidenced and you need to decide whether that friction is real

## Workflow

1. Start from the current round only.
   - Do not generalize from memory alone.
2. Check for confirmed friction such as:
   - repeated manual work
   - avoidable toolchain friction
   - missing or weak skills
   - missing or weak MCP support
   - weak repo workflow or reporting structure
   - `CJMP` framework or tooling gaps that increased delivery cost
   - acceptance tooling, runtime setup, device control, screenshot capture, or evidence collection friction that increased acceptance cost or weakened validation quality
3. Separate confirmed friction from annoyance or speculation.
   - Confirmed friction needs concrete evidence from the round.
   - Speculation should not become an issue.
4. If no confirmed friction exists:
   - state `no confirmed AI-efficiency friction in this round`
5. If confirmed friction exists:
   - write a concise friction summary
   - include the blocked or slowed step
   - include the workaround or repeated effort
   - include the concrete delivery, acceptance, or comparison impact
6. Decide whether the friction belongs in a GitHub issue tagged `ai-efficiency`.
   - Create the issue when the problem is durable, actionable, and belongs to this repo's AI delivery setup or to confirmed `CJMP` delivery friction worth tracking here.
7. Add durable context under `reports/cjmp-issues/` when the issue needs longer-form evidence for later comparison work.

## Output requirements

The friction check should end with one of these outcomes:

- `no confirmed AI-efficiency friction in this round`
- a confirmed friction summary with evidence

## Quality bar

- Only raise `ai-efficiency` issues for real, repeated, or clearly costly problems.
- Do not create issues for vague discomfort or one-off mistakes.
- Keep the evidence concrete enough that another agent can understand the problem later.
- For acceptance rounds, prefer evidence about blocked validation, weak observability, runtime setup cost, or poor tool support over generic frustration wording.
