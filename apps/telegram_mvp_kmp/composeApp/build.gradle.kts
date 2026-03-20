plugins {
    id("com.android.application")
    id("org.jetbrains.compose")
    id("org.jetbrains.kotlin.multiplatform")
    id("org.jetbrains.kotlin.plugin.compose")
}

kotlin {
    androidTarget()

    sourceSets {
        androidMain.dependencies {
            implementation(project(":shared"))
            implementation("androidx.activity:activity-compose:1.10.1")
        }
    }
}

android {
    namespace = "com.hypheng.telegrammvpkmp.composeapp"
    compileSdk = 35

    defaultConfig {
        applicationId = "com.hypheng.telegrammvpkmp"
        minSdk = 26
        targetSdk = 35
        versionCode = 1
        versionName = "0.1.0"
    }

    buildFeatures {
        compose = true
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
}
