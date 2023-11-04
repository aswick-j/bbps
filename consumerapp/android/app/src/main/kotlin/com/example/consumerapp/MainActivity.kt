package com.example.consumerapp

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES

class MainActivity: FlutterActivity() {
   private val BACK_BUTTON_CHANNEL = "equitas.flutter.fas/backButton"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, BACK_BUTTON_CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "triggerBackButton") {
                    onBackPressed()
                    result.success(true)
                } else {
                    result.notImplemented()
                }
            }
    }

    override fun onBackPressed() {
        super.onBackPressed()
    }
    
}