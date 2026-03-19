# Flutter Codex Delivery Setup

## Goal

Set up the `flutter` lane for Codex-based development by using Flutter's official AI delivery stack where it ports cleanly, instead of inventing a repo-specific Flutter replacement.

## Official Flutter Baseline

The `flutter` lane should follow the official Flutter AI path:

- Flutter AI hub: `https://docs.flutter.dev/ai`
- Dart and Flutter MCP server: `https://docs.flutter.dev/ai/mcp-server`
- Flutter AI rules: `https://docs.flutter.dev/ai/ai-rules`

The official MCP path for Codex is:

```bash
codex mcp add dart -- dart mcp-server --force-roots-fallback
```

This repo mirrors that as project-scoped Codex config in `.codex/config.toml` with:

- `command = "dart"`
- `args = ["mcp-server", "--force-roots-fallback"]`

## What The Flutter MCP Server Provides

The Dart and Flutter MCP server exposes Dart and Flutter development tool actions to AI clients. Flutter documents it as the bridge between an AI assistant and Dart/Flutter developer tools.

For this project, the important capability categories are:

- code analysis and fix support:
  - analyze project errors
  - help apply fixes with tool-backed context
- symbol and API resolution:
  - resolve symbols to real elements
  - fetch signature and documentation information
- runtime and UI introspection:
  - inspect the running application
  - introspect the widget tree
  - see runtime errors
  - help debug layout issues
- runtime control:
  - trigger hot reloads
  - trigger restarts
- package and dependency workflow:
  - search `pub.dev`
  - add and manage dependencies in `pubspec.yaml`
- verification and formatting:
  - run tests and analyze results
  - format code with the same formatter/config as Dart tooling

Flutter's higher-level AI overview summarizes the practical value of the MCP server as:

- introspecting the widget tree to debug layout issues
- managing dependencies by searching `pub.dev` and adding packages
- controlling the runtime with hot reload and restart
- fixing complex static and runtime errors with deeper context

## What The Flutter MCP Server Does Not Provide By Itself

The MCP server is not the whole Flutter AI workflow. It provides tool access, not the complete framework workflow policy.

Important boundaries:

- it does not replace Flutter rules files
- it does not define this repo's delivery workflow
- it does not create Codex-specific slash commands for us
- it is not the same thing as the Flutter extension for Gemini CLI

Flutter's Gemini CLI extension combines three things:

- the Dart and Flutter MCP server
- the official Flutter and Dart AI rules
- extra commands such as `/create-app` and `/modify`

This repo only ports the parts that cleanly fit Codex:

- the official Dart and Flutter MCP server
- the official Flutter rules

It does not attempt to recreate the Gemini CLI extension command layer inside Codex.

## MCP Client Requirements

Flutter documents these client expectations:

- the MCP client must support `stdio`
- to access all features, the client must support `Tools` and `Resources`
- for the best experience, the client should also support `Roots`

If a client claims root support but does not actually set roots, Flutter recommends passing `--force-roots-fallback`. That is why this repo uses:

```toml
args = ["mcp-server", "--force-roots-fallback"]
```

## Repo Setup

This repo now carries the Flutter AI-infra pieces that port cleanly to Codex:

- project-scoped Codex MCP config:
  - `.codex/config.toml`
- Flutter Codex lane guidance:
  - `.codex/agents/developer-flutter.toml`
  - `.codex/roles/developer-flutter.md`
- vendored official Flutter rules:
  - `.codex/rules/flutter-rules-4k.md`

## Official Flutter Rules

Flutter publishes official rules templates in multiple sizes:

- `rules.md`
- `rules_10k.md`
- `rules_4k.md`
- `rules_1k.md`

For Codex in this repo:

- treat `.codex/rules/flutter-rules-4k.md` as the framework guidance source
- keep repo-local Flutter instructions focused on lane setup and comparison discipline
- do not replace the official Flutter rules with a repo-invented Flutter coding policy

If a future workflow needs a local Codex-specific adaptation, derive it from the official Flutter rules rather than writing a new framework policy from scratch.

## What Ports Cleanly To Codex

- official Dart and Flutter MCP server
- official Flutter rules vendored locally
- framework-aware tooling through MCP
- shared repo workflow for issues, implementation, acceptance, and comparison
- lane-specific Flutter instructions in the Flutter developer subagent

## What Should Not Be Re-Invented Here

- a custom Flutter-only Codex MCP bridge
- a repo-specific replacement for Flutter's official AI rules
- a fake Codex clone of the Gemini CLI extension command layer
- custom local Flutter workflow abstractions when the official Flutter stack already covers the framework-specific part

## Environment Notes

The Dart and Flutter MCP server is documented by Flutter as experimental and requiring Dart `3.9` or later.

If the local environment cannot start `dart mcp-server`, record that as setup friction in comparison artifacts instead of hiding it.

## Sources

- `https://docs.flutter.dev/ai`
- `https://docs.flutter.dev/ai/create-with-ai`
- `https://docs.flutter.dev/ai/mcp-server`
- `https://docs.flutter.dev/ai/ai-rules`
