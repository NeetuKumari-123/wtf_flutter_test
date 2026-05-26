plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.wtf_flutter_test"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.wtf_flutter_test"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }
    buildTypes {
         release {
        isMinifyEnabled = true
        isShrinkResources = true

        proguardFiles(
            getDefaultProguardFile("proguard-android-optimize.txt"),
            "proguard-rules.pro"
        )

        signingConfig = signingConfigs.getByName("debug")
    }
}

    // buildTypes {
    //     release {
    //         // TODO: Add your own signing config for the release build.
    //         // Signing with the debug keys for now, so `flutter run --release` works.
    //         signingConfig = signingConfigs.getByName("debug")
    //     }
    // }
}

flutter {
    source = "../.."
}


dependencies {
    implementation("com.google.protobuf:protobuf-javalite:3.21.12")
}