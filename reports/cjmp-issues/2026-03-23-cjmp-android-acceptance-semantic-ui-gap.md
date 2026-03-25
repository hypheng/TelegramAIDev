# 2026-03-23 CJMP Android acceptance semantic UI gap

## Summary

During Android emulator acceptance for CJMP requirement issue `#17`, the CJMP slice-1 app rendered visible text and controls on screen, but `uiautomator dump` exposed only the top-level `FrameLayout` and system bar nodes. The acceptance round therefore could not select elements by text, content description, or resource id and had to fall back to screenshot inspection plus raw coordinate taps.

## Evidence

- Screenshot with visible CJMP login shell: `.cache/android-acceptance/cjmp-issue-17-20260323/01-first-launch.png`
- Screenshot after CTA tap: `.cache/android-acceptance/cjmp-issue-17-20260323/02-after-continue.png`
- UI dump before CTA: `.cache/android-acceptance/cjmp-issue-17-20260323/01-first-launch.xml`
- UI dump after CTA: `.cache/android-acceptance/cjmp-issue-17-20260323/02-after-continue.xml`

The XML dumps contain only:

- `android:id/content`
- `android:id/statusBarBackground`
- `android:id/navigationBarBackground`

while the screenshots clearly show the `Telegram Demo` title, phone field, and `Continue` button.

## Acceptance impact

- weakened runtime observability for CJMP acceptance
- forced coordinate-based interaction instead of selector-based interaction
- reduced confidence and speed for cross-framework comparable acceptance rounds
- makes future bug reproduction and automation more fragile

## Workaround used in this round

- inspect screenshots manually
- tap the visible button with raw coordinates: `android_acceptance.py tap --serial emulator-5554 --x 540 --y 1245`

## Suggested follow-up

- expose accessible semantic nodes for CJMP-rendered Android UI where possible
- ensure visible text/buttons are discoverable through Android UI hierarchy dumps used by shared acceptance tooling
