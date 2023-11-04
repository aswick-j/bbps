package com.example.bbps

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "bbps"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Set up a method channel to handle method calls from Flutter
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "navigateBackToMainApp" -> {
                    // Handle the navigation back to the main app here
                    // For example, you can finish the current activity to return to the previous screen
                    finish()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }
}
