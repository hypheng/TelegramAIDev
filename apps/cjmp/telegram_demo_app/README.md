# telegram_demo_cjmp

Keels-based CJMP app for the Telegram commercial MVP comparison repo.

Current delivered scope:

- issue `#17`
- slice `#1` app shell and startup routing
- startup loading gate
- no-session login handoff shell
- startup failure notice with retry
- canonical shared slice-1 assets copied locally and generated into CJ source

Key commands:

```bash
cd /Users/haifengsong/code-base/telegram/TelegramAIDev/apps/cjmp/telegram_demo_app
python3 tools/sync_shared_assets.py
keels build apk --platform android-arm64 --debug
```

Asset flow:

1. Canonical shared assets come from `shared/design/telegram-commercial-mvp/`.
2. `tools/sync_shared_assets.py` copies the required files into `assets/telegram-commercial-mvp/`.
3. The same sync step regenerates `lib/shared_assets_generated.cj` so the app consumes canonical slice data without reading the shared source tree at runtime.
