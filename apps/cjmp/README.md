# CJMP Lane

Issue `#17` bootstrapped the CJMP app lane under `apps/cjmp/telegram_demo_app`.

Use this lane for the Telegram commercial MVP CJMP implementation work. The current baseline is Android-first and uses a Keels app shell.

Common commands:

```bash
cd /Users/haifengsong/code-base/telegram/TelegramAIDev/apps/cjmp/telegram_demo_app
python3 tools/sync_shared_assets.py
keels build apk --platform android-arm64 --debug
```

Shared asset rule:

- canonical source remains `shared/design/telegram-commercial-mvp/`
- app-local copied assets live under `apps/cjmp/telegram_demo_app/assets/telegram-commercial-mvp/`
- generated slice data lives in `apps/cjmp/telegram_demo_app/lib/shared_assets_generated.cj`
