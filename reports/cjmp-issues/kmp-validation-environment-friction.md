# KMP validation environment friction

Round: KMP requirement #1 startup-routing implementation
Date: 2026-03-20

## Evidence

KMP validation in this workspace needed writable temp homes to finish the standard Gradle loop.

Observed failures before the workaround:
- Kotlin daemon temp files tried to write under `~/Library/Application Support/kotlin/daemon`
- Android debug keystore creation tried to write under `~/.android`

Commands that succeeded only after the workaround:
- `GRADLE_USER_HOME=/tmp/gradle-home-kmp ./gradlew :shared:jvmTest --no-daemon`
- `ANDROID_SDK_HOME=/tmp/android-sdk-home GRADLE_USER_HOME=/tmp/gradle-home-kmp ./gradlew :composeApp:assembleDebug --no-daemon`

## Workaround used

- `GRADLE_USER_HOME=/tmp/gradle-home-kmp`
- `ANDROID_SDK_HOME=/tmp/android-sdk-home`

## Impact

- KMP validation is harder to reproduce from the repo alone.
- Future KMP delivery or acceptance rounds can easily forget the required environment setup.
- The extra environment setup adds avoidable delivery friction.

## Tracking

- GitHub issue: https://github.com/hypheng/TelegramAIDev/issues/10
