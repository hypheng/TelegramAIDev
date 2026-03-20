# telegram_mvp_kmp

KMP lane implementation for the Telegram commercial MVP.

## Structure

- `shared/`: shared KMP state, UI, design catalog loading, and startup routing
- `composeApp/`: Android application shell that hosts the shared Compose UI

## Shared design resources

The shared module consumes the design resources that are linked from:

- `docs/design/figma-source/index.html`
- `docs/design/assets/icons/`
- `docs/design/assets/mock-data.json`

These files are the framework-agnostic source of truth for the startup-routing slice.
