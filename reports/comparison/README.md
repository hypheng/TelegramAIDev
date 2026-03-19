# Comparison

Store cross-framework comparison artifacts here.

Use two layers of artifacts:

- framework-specific round logs: append per-round updates here
- aggregate comparison reports: keep these concise and synthesize from the round logs

Recommended file contents:

- slice or topic being compared
- current status in `CJMP`, `KMP`, and `flutter`
- observed AI delivery friction
- parity or quality gaps
- next comparison or investigation step

## File Convention

For a slice named `telegram-commercial-mvp`, prefer:

- aggregate report: `reports/comparison/telegram-commercial-mvp-comparison-overview.md`
- `CJMP` round log: `reports/comparison/telegram-commercial-mvp-cjmp-rounds.md`
- `KMP` round log: `reports/comparison/telegram-commercial-mvp-kmp-rounds.md`
- `flutter` round log: `reports/comparison/telegram-commercial-mvp-flutter-rounds.md`

## Current Round Update Convention

When a developer or acceptance round finishes, update the relevant framework-specific round log in the same round.
Do not append every round directly into the aggregate overview.

Recommended entry shape:

- timestamp
- framework lane
- work item type and issue or PR reference
- concise working effort summary
- total duration
- internal step duration
- token consumption or `not observable`
- validation completed in the round
- parity impact, delivery status change, or notable workaround
- AI-efficiency friction summary, or an explicit `no confirmed friction in this round`

## Aggregate Overview Convention

Aggregate overviews should stay compact.

Use them for:

- current cross-framework delivery status
- synthesized parity gaps
- accumulated friction patterns worth comparing
- rollup conclusions and next investigation steps

Do not use them as append-only round journals.
