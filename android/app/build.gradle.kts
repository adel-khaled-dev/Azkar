plugins {
    id("com.android.application")
    // ✅ تم حذف id("kotlin-android") والانتقال إلى Kotlin المدمج
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.adelkhalid.azkar"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    // ✅ تم حذف kotlinOptions القديمة

    defaultConfig {
        applicationId = "com.adelkhalid.azkar"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

// ✅ طريقة Built-in Kotlin الجديدة الموصى بها من Flutter
kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
}

flutter {
    source = "../.."
}
