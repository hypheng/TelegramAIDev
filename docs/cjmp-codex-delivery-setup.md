# CJMP Codex Delivery Setup

## Goal

Set up the `CJMP` lane for Codex-based development around the current `CJMP` AI infrastructure that actually exists today, without pretending that `CJMP` already has a Flutter-like framework MCP stack.

## Current CJMP Baseline

The current known `CJMP` AI engineering infrastructure is:

- Context7 library:
  - `https://context7.com/hypheng/cjmp-ai-docs`
  - library ID: `/hypheng/cjmp-ai-docs`

This means the current `CJMP` AI baseline is a documentation and code-example knowledge source, not a framework tool bridge.

## What Context7 Provides For CJMP

Context7 is a documentation grounding system. Its MCP flow provides:

- up-to-date documentation lookup
- source-grounded code examples
- library resolution by name or known library ID
- documentation context injected into the coding session

For the `CJMP` lane, that means agents can use Context7 as the primary current knowledge source for:

- framework concepts
- documented APIs
- code examples
- setup references
- implementation guidance that exists in the indexed docs

## What Context7 Does Not Provide For CJMP

Context7 does not provide framework runtime or tool actions by itself.

It does not give `CJMP` a Flutter-like MCP surface for:

- project code analysis
- compile or lint error inspection
- symbol resolution against the live project
- runtime error inspection
- running app introspection
- widget tree or UI tree introspection
- hot reload or app restart control
- test execution
- code formatting
- package or dependency management

So the current `CJMP` AI baseline is documentation-only infrastructure, not framework-tool infrastructure.

## Comparison With Flutter MCP

Flutter's official Dart and Flutter MCP server is a much broader AI delivery layer.

Flutter MCP provides tool-backed capabilities such as:

- project analysis and fix support
- symbol and API resolution
- running app and widget tree introspection
- runtime error inspection
- hot reload and restart control
- `pub.dev` search and dependency management
- test execution
- formatting

By contrast, the current `CJMP` Context7 library provides only:

- documentation retrieval
- code examples
- current framework knowledge grounding

## CJMP Gap Versus Flutter MCP

Relative to Flutter MCP, the current `CJMP` gap is:

1. No framework-native tool bridge.
   `CJMP` currently has documentation context, but no MCP layer exposing framework or project actions.

2. No runtime introspection.
   There is no `CJMP` equivalent of widget tree inspection, runtime error surfacing, or app-state inspection through MCP.

3. No framework-aware code operations.
   There is no `CJMP` MCP layer for analysis, symbol lookup, tests, formatting, or dependency operations.

4. No official framework rules layer comparable to Flutter's published AI rules.

5. No official multi-client setup path comparable to Flutter's documented Codex and other AI-client integration recipes.

6. The current `CJMP` AI path depends on successful Context7 access.
   In the current environment, `context7` is enabled in Codex but not authenticated, so even the documentation path is not fully ready yet.

## What This Repo Should Use Right Now

For the `CJMP` lane in this repo:

- use Context7 library `/hypheng/cjmp-ai-docs` as the primary current `CJMP` knowledge source
- treat it as documentation grounding only
- do not claim `CJMP` has Flutter-equivalent MCP capabilities
- record every missing tool capability as explicit comparison friction when it materially slows delivery or weakens validation

## Practical Setup For This Repo

1. Keep `context7` enabled in Codex.
2. Authenticate Context7 in the Codex client so the `CJMP` docs library is actually reachable.
3. In the `CJMP` developer role, direct agents to use `/hypheng/cjmp-ai-docs` before substantive `CJMP` implementation work.
4. Record any case where documentation is insufficient and a missing framework-aware tool surface causes measurable extra effort.

## Sources

- `https://context7.com/docs`
- `https://context7.com/docs/installation`
- `https://context7.com/docs/agentic-tools/overview`
- `https://context7.com/docs/clients/cli`
- `https://context7.com/hypheng/cjmp-ai-docs`
- `https://docs.flutter.dev/ai/mcp-server`
