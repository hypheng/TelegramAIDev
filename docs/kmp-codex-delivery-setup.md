# KMP Codex Delivery Setup

## Goal

Set up the `KMP` lane for Codex-based development by combining:

- the official Kotlin Multiplatform and JetBrains delivery baseline, and
- a Codex-usable documentation grounding source through Context7

without pretending that `KMP` already has a Flutter-like framework MCP server.

## Current KMP Codex Knowledge Sources

For Codex-based `KMP` development in this repo, use these Context7 libraries together:

- Kotlin Multiplatform docs repo:
  - `https://context7.com/jetbrains/kotlin-multiplatform-dev-docs`
  - library ID: `/jetbrains/kotlin-multiplatform-dev-docs`
- Kotlin website docs:
  - `https://context7.com/websites/kotlinlang`
  - library ID: `/websites/kotlinlang`

The first library is grounded in the official Kotlin Multiplatform docs repository:

- `https://github.com/jetbrains/kotlin-multiplatform-dev-docs`

Use them with this priority:

1. `/jetbrains/kotlin-multiplatform-dev-docs` for Kotlin Multiplatform-specific guidance
2. `/websites/kotlinlang` for broader Kotlin language, tooling, and official site documentation

## What This Provides For KMP In Codex

For the `KMP` lane, these Context7 libraries give Codex a current documentation and code-example grounding source for:

- Kotlin Multiplatform concepts
- official setup guidance
- API and framework docs
- code examples from the official docs corpus
- implementation references when working across Kotlin Multiplatform slices

This is useful because the official `KMP` AI baseline is primarily JetBrains-native, while Codex needs a portable documentation source it can query directly.

## What This Does Not Provide

These Context7 libraries do not turn `KMP` into a Flutter-style MCP workflow.

It does not provide:

- KMP project analysis through MCP
- live symbol resolution against the current project
- runtime inspection
- Compose tree or UI introspection
- hot reload control
- test execution through MCP
- formatting through MCP
- dependency management through MCP

So in the Codex lane, this library should be treated as documentation grounding, not as framework-native tool integration.

## Relationship To The Official KMP AI Baseline

The official KMP AI baseline still comes from the JetBrains and Kotlin ecosystem:

- Kotlin Multiplatform plugin and IDE tooling
- Junie
- AI Assistant project rules

For this repo's Codex-based comparison lane:

- use the official JetBrains/KMP docs and Kotlin site docs as the product and framework source of truth
- use Context7 libraries `/jetbrains/kotlin-multiplatform-dev-docs` and `/websites/kotlinlang` as the Codex-accessible knowledge sources
- do not claim this is equivalent to a KMP-native MCP server

## Practical Setup For This Repo

1. Keep `context7` enabled in Codex.
2. Authenticate Context7 in the Codex client so both KMP knowledge libraries are reachable.
3. In the `KMP` developer role, direct agents to use `/jetbrains/kotlin-multiplatform-dev-docs` first and `/websites/kotlinlang` as the secondary official Kotlin source.
4. If either library is unavailable, unauthenticated, or insufficient, record the setup gap in comparison artifacts.

## Sources

- `https://context7.com/jetbrains/kotlin-multiplatform-dev-docs`
- `https://context7.com/websites/kotlinlang`
- `https://github.com/jetbrains/kotlin-multiplatform-dev-docs`
- `https://kotlinlang.org/multiplatform/`
- `https://kotlinlang.org/docs/multiplatform/quickstart.html`
