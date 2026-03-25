# Keels canonical asset ingestion path was unclear during CJMP slice-1 delivery

- issue: `#55`
- date: `2026-03-23`
- affected round: CJMP requirement `#17`
- category: CJMP delivery friction

## What happened

The CJMP slice-1 implementation needed to follow the repo-wide shared asset rule:

- canonical source stays in `shared/design/telegram-commercial-mvp/`
- the framework app copies required assets into its own runtime-local path
- the app must not read the shared source tree directly at runtime

During the new Keels app bootstrap, the current CJMP/Keels path did not provide a clear, documented, low-friction way to consume the copied app-local JSON/SVG assets directly inside the app runtime.

To stay within the repo contract without inventing framework-local data, the round added a local workaround:

- copy the canonical files into `apps/cjmp/telegram_demo_app/assets/telegram-commercial-mvp/`
- generate `apps/cjmp/telegram_demo_app/lib/shared_assets_generated.cj`
- keep the runtime on generated CJ constants instead of direct reads from the shared source tree

## Why it matters

- increased CJMP delivery cost during the first lane bootstrap
- required extra repo-local tooling before product logic could proceed
- will likely recur in later CJMP slices that depend on shared canonical assets

## Evidence

- `/Users/haifengsong/code-base/telegram/TelegramAIDev/apps/cjmp/telegram_demo_app/tools/sync_shared_assets.py`
- `/Users/haifengsong/code-base/telegram/TelegramAIDev/apps/cjmp/telegram_demo_app/assets/telegram-commercial-mvp/shared-copy.json`
- `/Users/haifengsong/code-base/telegram/TelegramAIDev/apps/cjmp/telegram_demo_app/lib/shared_assets_generated.cj`
- validation command: `cd /Users/haifengsong/code-base/telegram/TelegramAIDev/apps/cjmp/telegram_demo_app && keels build apk --platform android-arm64 --debug`

## Suggested follow-up

Provide a clear, documented CJMP/Keels pattern for consuming copied app-local canonical assets such as JSON and SVG resources inside app code without forcing generated-source workarounds.
