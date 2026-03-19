# Telegram Commercial MVP Design

## Scope

Framework-agnostic UI and interaction design for the Telegram-like commercial MVP.

Related requirement: `docs/requirements/telegram-commercial-mvp.md`
Related acceptance: `docs/acceptance/telegram-commercial-mvp.md`

## Figma Status

- Figma artifact: pending
- Until the Figma file is created, this document is the source of truth for framework-agnostic design decisions.

## Product Structure

- Launch / restore gate
- Login flow
- Chat list
- Chat detail

## Screen Inventory

### Launch / Restore

- brief loading state while checking session
- route to login if no valid session
- route to chat list if session is valid

### Login

- title and short explanatory text
- phone input
- primary continue CTA
- lightweight verification step for demo entry
- inline validation and failure messaging

### Chat List

- top app bar with product title and primary actions
- vertically scrolling conversation list
- each row includes:
  - avatar
  - conversation title
  - last message snippet
  - timestamp
  - unread badge when needed
  - pinned / muted cues where relevant

### Chat Detail

- top bar with conversation title and back navigation
- scrollable message history
- incoming and outgoing bubbles
- date separators
- composer with text input and send action

## Interaction States

### Global

- initial loading
- recoverable error

### Login

- empty input
- invalid input
- submitting
- verification success
- verification failure

### Chat List

- loading
- populated list
- empty list
- load failure

### Chat Detail

- loading conversation
- populated conversation
- local send pending
- local send complete
- recoverable send failure

## Visual Direction

- aim for a Telegram-like hierarchy rather than a minimal debug dashboard
- prioritize readable density, clear timestamps, legible snippets, and familiar chat affordances
- use a restrained accent color and neutral surfaces
- keep touch targets production-credible on mobile

## Design Rules

- stay framework-agnostic
- do not leak framework-specific state containers or architectural decisions into the UI spec
- prefer reusable structural components across all three frameworks
- define the major states that materially affect implementation complexity and acceptance

## Figma Follow-Up

When the Figma file is created, it should include at least:

1. login
2. login validation state
3. chat list default state
4. chat list loading or empty state
5. chat detail default state
6. chat detail send-pending state
