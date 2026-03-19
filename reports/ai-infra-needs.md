# AI Infra Needs Analysis

## Goal

Identify what AI delivery infrastructure this project should set up to compare `CJMP`, `KMP`, and `flutter` fairly while building a Telegram-like commercial MVP.

The key policy is:

- for `flutter` and `KMP`, adopt current official or ecosystem-standard AI delivery infrastructure instead of inventing new framework-specific infrastructure
- for `CJMP`, identify the starting gap and build the missing AI delivery infrastructure deliberately

## Research Scope

This pass focused on:

- Flutter official AI delivery infrastructure, starting from `https://flutter.dev/ai`
- whether `KMP` has a similar official AI delivery infrastructure
- what this repo should actually set up next

This pass reviewed official `flutter` and `KMP` sources and the currently known `CJMP` AI source:

- Context7 library: `https://context7.com/hypheng/cjmp-ai-docs`

Any ecosystem-level `CJMP` statements below should still be read narrowly as:

- what the current known `CJMP` AI path provides for this repo, and
- what gaps remain relative to the stronger official `flutter` and `KMP` baselines

## What "SOTA" Means In This Repo

For this project, "SOTA" should not mean "force every framework into the same custom Codex-only workflow."

It should mean:

- `flutter`: use Flutter's current official AI delivery stack
- `KMP`: use JetBrains and Kotlin's current official AI-enabled delivery stack
- `CJMP`: measure the gap against those stronger baselines, then improve `CJMP` deliberately

This is important for comparison quality. If `flutter` or `KMP` already have strong official AI infrastructure, the project should benefit from that instead of flattening the benchmark by avoiding it.

## Shared Repo Infrastructure

Regardless of framework, this repo still needs a shared project layer:

- GitHub issue and PR workflow
  - requirement-driven planning
  - bug follow-up
  - `ai-efficiency` follow-up
- Figma workflow
  - framework-agnostic design before implementation
- acceptance execution workflow
  - `adb`, screenshots, simulated touch, scenario-driven validation
- comparison workflow
  - wall-clock time
  - finish time accurate to the second
  - stage-by-stage time accounting
  - token accounting where the underlying tool makes it observable
- durable reporting
  - `reports/comparison/`
  - `reports/cjmp-issues/`

These are repo responsibilities, not framework-specific inventions.

## Flutter Official AI Delivery Infrastructure

### What Exists Officially

- Flutter has an official AI hub: `https://flutter.dev/ai`
- Flutter has an official Dart and Flutter MCP server:
  - `https://docs.flutter.dev/ai/mcp-server`
  - the page says it is experimental
  - the page requires Dart `3.9` or later
  - the page reflects Flutter `3.41.2`
  - the page was updated on `2026-01-27`
- The Dart and Flutter MCP server officially supports AI-assistant clients through stdio MCP and exposes framework-aware actions such as:
  - analyzing and fixing errors
  - symbol resolution and docs lookup
  - interacting with a running app
  - searching `pub.dev`
  - managing dependencies
  - running tests
  - formatting code
- Flutter officially documents setup paths for multiple AI clients, including:
  - Gemini CLI
  - Firebase Studio
  - Gemini Code Assist
  - GitHub Copilot
  - Cursor
  - OpenCode
  - Claude Code
  - Codex CLI
- Flutter also publishes official AI rules templates:
  - `https://docs.flutter.dev/ai/ai-rules`
  - includes `rules.md`, `rules_10k.md`, `rules_4k.md`, `rules_1k.md`
  - includes tool/editor-specific guidance for where to place those rules
  - page updated on `2026-01-05`
- Flutter publishes an official Flutter extension for Gemini CLI:
  - `https://docs.flutter.dev/ai/gemini-cli-extension`
  - page updated on `2026-01-07`
  - the extension auto-configures the Dart and Flutter MCP server
  - it includes built-in best-practice rules
  - it adds structured commands such as `/create-app`, `/create-package`, `/modify`, and `/commit`

### What This Means

`flutter` already has a coherent first-party AI delivery stack:

- official AI landing page
- official framework MCP server
- official framework rules
- official multi-client integration recipes
- official agent workflow extension

This is stronger than a generic "use an LLM in an editor" story.

### What We Should Set Up For This Repo

- Treat the official Dart and Flutter MCP server as the default agent-tool layer for `flutter`
- For a Codex-based lane, start from Flutter's documented Codex setup example:
  - `codex mcp add dart -- dart mcp-server --force-roots-fallback`
- For Codex-based development in this repo, use Context7 library `https://context7.com/websites/flutter_dev` as the supplemental Flutter documentation grounding source
- Keep the `flutter` lane on a toolchain compatible with the official MCP path
- Reuse Flutter's official AI rules rather than inventing new `flutter`-specific rules
- If Gemini CLI is part of the comparison benchmark, use the official Flutter Gemini CLI extension instead of building a parallel local workflow
- If Codex is used for the `flutter` lane, use Flutter's official Codex MCP setup path rather than a custom bridge

### Boundary

Do not invent new `flutter` framework-specific AI infrastructure in this repo unless the explicit goal is to benchmark something Flutter does not already provide.

## KMP Official AI Delivery Infrastructure

### What Exists Officially

- Kotlin Multiplatform's official site explicitly positions AI-powered delivery around:
  - Junie
  - the Kotlin Multiplatform IDE plugin
  - `https://kotlinlang.org/multiplatform/`
- Official KMP quickstart and plugin docs provide a strong IDE-native baseline:
  - latest plugin path
  - preflight environment checks
  - generated run configurations
  - Swift and Kotlin cross-language navigation and debugging
  - Compose previews
  - Compose Hot Reload
  - quickstart updated on `2026-03-18`
  - sources:
    - `https://kotlinlang.org/docs/multiplatform/quickstart.html`
    - `https://kotlinlang.org/docs/multiplatform/multiplatform-plugin-releases.html`
- JetBrains Junie is an official AI coding agent:
  - `https://www.jetbrains.com/help/idea/junie.html`
  - it works with project context
  - it can search code, edit code, run tests, and verify results
- JetBrains AI Assistant supports project rules:
  - `https://www.jetbrains.com/help/ai-assistant/configure-project-rules.html`
  - rules live under `.aiassistant/rules/*.md`
  - rules can be Always, Manually, By model decision, or By file patterns
- JetBrains documentation also points to Junie support for:
  - project guidelines
  - MCP
  - sources:
    - `https://www.jetbrains.com/help/junie/customize-guidelines.html`
    - `https://www.jetbrains.com/help/junie/model-context-protocol-mcp.html`
- JetBrains AI Enterprise documents provider-backed AI setup for Junie and AI Assistant:
  - `https://www.jetbrains.com/help/ide-services/manage-aie.html`

### What This Means

`KMP` does have strong official AI delivery infrastructure, but its shape is different from `flutter`.

It is primarily:

- IDE-native
- agent-enabled through Junie
- rule-driven through AI Assistant and Junie guidelines
- tooling-rich through the KMP plugin and Compose tooling

In the official sources reviewed here, I did not find:

- a `KMP`-specific MCP server comparable to Flutter's Dart and Flutter MCP server
- a `KMP`-specific agent CLI extension comparable to the Flutter extension for Gemini CLI

So `KMP` has strong official AI infrastructure, but it is not the same kind of infrastructure as `flutter`.

### What We Should Set Up For This Repo

- Standardize the `KMP` lane on the latest supported KMP plugin and compatible IDE versions
- Treat Junie plus AI Assistant project rules as the official JetBrains-native delivery baseline for `KMP`, not as the Codex execution layer
- For Codex-based development in this repo, use Context7 libraries `https://context7.com/jetbrains/kotlin-multiplatform-dev-docs` and `https://context7.com/websites/kotlinlang` as the default KMP documentation grounding sources
- Reuse portable KMP guidance inside Codex role prompts and setup docs rather than carrying Junie-specific repo files that Codex does not use
- Use generic MCP only where Junie benefits from it, but do not present it as official framework-native `KMP` MCP infrastructure

### Boundary

Do not invent new `KMP` framework-specific AI infrastructure in this repo unless the explicit goal is to benchmark or close a known missing capability.

## CJMP Starting Gap Baseline

### What We Can Say Now

The current known `CJMP` AI engineering infrastructure is the Context7 library:

- `https://context7.com/hypheng/cjmp-ai-docs`
- library ID: `/hypheng/cjmp-ai-docs`

That gives `CJMP` a usable current knowledge source for agents, but it is a documentation-grounding path, not a framework-native MCP tool surface.

So based on the current known setup, `CJMP` starts with:

- a framework documentation and code-example knowledge source through Context7

and starts without:

- a `CJMP` framework MCP server
- `CJMP` runtime introspection through MCP
- `CJMP` tool-backed project analysis, symbol resolution, testing, formatting, or dependency management through MCP
- official `CJMP` AI rules comparable to Flutter's official rules
- official multi-client integration recipes comparable to Flutter's documented integrations

### Contrast-Based Gap Signals

By contrast with the researched official ecosystems:

- `flutter` already has official framework rules, an official framework MCP server, official multi-client integration recipes, and an official workflow extension
- `KMP` already has official IDE-native AI delivery through the KMP plugin, Junie, AI Assistant rules, and related tooling

This means the `CJMP` starting gap is likely concentrated in:

- framework-aware tool integration
- runtime and project introspection
- framework-specific agent workflow guidance
- measurement and reporting discipline

More specifically, compared with Flutter MCP, the current known `CJMP` gap is:

- docs grounding exists, but no framework-native tool bridge exists
- no running-app or UI-tree introspection exists through MCP
- no project analysis, test, format, or dependency-management MCP path exists
- no official framework rules layer exists
- no official documented Codex-oriented setup path exists

The current environment also shows a practical setup gap:

- `context7` is enabled in Codex, but is currently `Not logged in`
- so even the documentation path is not fully operational until authentication is completed

### Evidence Boundary

This is not proof that the broader `CJMP` ecosystem lacks those things forever.

It is a statement about:

- what the currently known `CJMP` AI source provides
- what the current Codex environment can actually use today
- what the stronger `flutter` and `KMP` baselines already provide officially

## What This Project Should Set Up Next

### P0 Shared

- GitHub MCP and project-capable GitHub auth
- Figma MCP
- acceptance execution tooling and scripts
- time, finish-time, and stage-time tracking
- comparison reporting template and workflow

### P0 Flutter

- Dart and Flutter MCP server in the AI client used for the `flutter` lane
- Flutter official AI rules integrated into the `flutter` lane workflow
- authenticate and verify Context7 access for `/websites/flutter_dev`
- use that library as the supplemental Flutter knowledge source in the Flutter developer lane
- optional Flutter Gemini CLI extension lane if the benchmark wants Flutter's official agent workflow as a reference path

### P0 KMP

- latest supported Kotlin Multiplatform plugin and IDE baseline
- Codex-oriented KMP setup docs and prompts
- authenticate and verify Context7 access for `/jetbrains/kotlin-multiplatform-dev-docs` and `/websites/kotlinlang`
- use those libraries as the default KMP knowledge sources in the KMP developer lane
- explicit documentation of JetBrains-native capabilities that do not port cleanly to Codex

### P0 CJMP

- authenticate and verify Context7 access for `/hypheng/cjmp-ai-docs`
- use that library as the default `CJMP` knowledge source in the `CJMP` developer lane
- document the `CJMP` boundary clearly: documentation grounding exists, but Flutter-like MCP capabilities do not
- define how `CJMP` time, friction, and workaround data will be captured
- use comparison rounds to identify which missing capability categories are the highest-value `CJMP` gaps

### P1

- repo-local skills that wrap the shared workflow:
  - time and token tracking
  - comparison reporting
  - acceptance
  - AI-efficiency gap capture
- a targeted official-source audit of `CJMP` ecosystem AI tooling

## Measurement Note

The repo should not assume token accounting will be equally observable across all lanes.

- `flutter` may be easier to instrument when using Codex plus the official MCP server
- `KMP` may rely more on IDE-native AI surfaces such as Junie and AI Assistant, where token accounting could be less transparent depending on provider and enterprise setup

So the minimum hard comparison metric should be:

- wall-clock time
- finish time accurate to the second
- stage-by-stage time

Token usage should be recorded where observable and explicitly marked unavailable where the official tool does not expose it cleanly.

## Revised Bottom Line

`flutter` should be benchmarked on top of its official AI delivery stack, not on a reduced generic workflow.

`KMP` should be benchmarked on top of JetBrains and Kotlin's official IDE-native AI stack, not on an invented parallel framework layer.

`CJMP` is the framework where this repo should spend its invention budget. The first job is not to out-invent `flutter` or `KMP`, but to identify and close the current `CJMP` gap against those stronger baselines.

## Sources

- Flutter AI hub: `https://flutter.dev/ai`
- Dart and Flutter MCP server: `https://docs.flutter.dev/ai/mcp-server`
- Flutter extension for Gemini CLI: `https://docs.flutter.dev/ai/gemini-cli-extension`
- Flutter AI rules: `https://docs.flutter.dev/ai/ai-rules`
- Flutter Context7 library: `https://context7.com/websites/flutter_dev`
- Context7 intro: `https://context7.com/docs`
- Context7 installation: `https://context7.com/docs/installation`
- Context7 agentic tools overview: `https://context7.com/docs/agentic-tools/overview`
- CJMP Context7 library: `https://context7.com/hypheng/cjmp-ai-docs`
- KMP Context7 library: `https://context7.com/jetbrains/kotlin-multiplatform-dev-docs`
- Kotlin website Context7 library: `https://context7.com/websites/kotlinlang`
- Kotlin Multiplatform site: `https://kotlinlang.org/multiplatform/`
- Kotlin Multiplatform quickstart: `https://kotlinlang.org/docs/multiplatform/quickstart.html`
- Kotlin Multiplatform plugin releases: `https://kotlinlang.org/docs/multiplatform/multiplatform-plugin-releases.html`
- JetBrains Junie: `https://www.jetbrains.com/help/idea/junie.html`
- JetBrains AI Assistant project rules: `https://www.jetbrains.com/help/ai-assistant/configure-project-rules.html`
- JetBrains Junie guidelines: `https://www.jetbrains.com/help/junie/customize-guidelines.html`
- JetBrains Junie MCP: `https://www.jetbrains.com/help/junie/model-context-protocol-mcp.html`
- JetBrains AI Enterprise: `https://www.jetbrains.com/help/ide-services/manage-aie.html`
- Kotlin AI-powered app development overview: `https://kotlinlang.org/docs/kotlin-ai-apps-development-overview.html`
