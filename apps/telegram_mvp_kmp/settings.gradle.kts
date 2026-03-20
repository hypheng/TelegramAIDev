pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
    plugins {
        id("com.android.application") version "8.7.3"
        id("com.android.library") version "8.7.3"
        id("org.jetbrains.kotlin.android") version "2.2.21"
        id("org.jetbrains.kotlin.multiplatform") version "2.2.21"
        id("org.jetbrains.kotlin.plugin.serialization") version "2.2.21"
        id("org.jetbrains.kotlin.plugin.compose") version "2.2.21"
        id("org.jetbrains.compose") version "1.9.2"
    }
}

dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.name = "telegram_mvp_kmp"
include(":shared")
include(":composeApp")
