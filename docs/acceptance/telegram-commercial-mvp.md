# Telegram Commercial MVP Acceptance

## Scope

This document defines the acceptance scenarios for the Telegram-like commercial MVP.

Related requirement: `docs/requirements/telegram-commercial-mvp.md`
Related design: `docs/design/telegram-commercial-mvp.md`

## Acceptance Scenario 1: First Launch Routes To Login

### Preconditions

- no valid local session exists

### Steps

1. Launch the app.
2. Wait for initial loading to finish.

### Pass Criteria

- the app lands on the login flow
- the user can see a primary CTA to continue
- the screen does not look like a developer placeholder or raw scaffold

## Acceptance Scenario 2: Demo Login Enters The Product

### Preconditions

- app is on the login flow

### Steps

1. Enter a demo phone number.
2. Continue through the verification step.
3. Complete login with the supported demo path.

### Pass Criteria

- the flow is understandable without developer knowledge
- invalid or incomplete input is handled with clear feedback
- successful completion routes the user into the chat list

## Acceptance Scenario 3: Session Restore Skips Login

### Preconditions

- a valid local session exists from a prior successful login

### Steps

1. Force close the app.
2. Reopen the app.

### Pass Criteria

- the app restores the session without requiring another login
- the user lands on chat list
- the transition does not expose broken intermediate states

## Acceptance Scenario 4: Chat List Feels Telegram-Like

### Preconditions

- user is authenticated

### Steps

1. Land on the chat list.
2. Inspect multiple chat rows.
3. Scroll through the list.

### Pass Criteria

- each row shows avatar, title, last-message snippet, timestamp, and unread state
- the list density and hierarchy feel close to a Telegram-like commercial app
- loading, empty, and error states are coherent and usable
- scrolling is stable and does not visibly degrade core usability

## Acceptance Scenario 5: Opening Chat Shows A Credible Conversation

### Preconditions

- chat list is visible

### Steps

1. Open a conversation from the list.
2. Inspect the message history.

### Pass Criteria

- incoming and outgoing messages are visually distinct
- date separators and delivery-state cues are shown where relevant
- the conversation is believable as a commercial messaging app, not a mock debug screen

## Acceptance Scenario 6: Sending A Local Text Message Works

### Preconditions

- chat detail is visible

### Steps

1. Type a text message.
2. Tap send.

### Pass Criteria

- the message appears in the conversation immediately
- the local sending state transitions to a stable sent state
- the composer clears after success
- the interaction feels responsive and not obviously broken

## Cross-Framework Acceptance Rule

- the same scenario set applies to `CJMP`, `KMP`, and `flutter`
- if one framework deviates, the difference must be recorded in `reports/comparison/telegram-commercial-mvp-baseline.md`

## Rejection Conditions

- the flow works only with developer shortcuts that are not part of the user-facing path
- UI quality is too low to support a credible Telegram-like demo
- one framework silently drops part of the slice without recording the gap
