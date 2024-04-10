package com.example.browser01

import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {
    private val flutterMethodChannelName = "flutterCallbackMethodChannel"
    private var methodChannel_callFlutter: MethodChannel? = null
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        methodChannel_callFlutter = flutterEngine?.dartExecutor?.binaryMessenger
            ?.let { MethodChannel(it, flutterMethodChannelName) }
        flutterEngine?.dartExecutor?.let {
            MethodChannel(it, CHANNEL).apply {
                val greetings = successNativeCode(intent)
                invokeMethod(InvokeMethod,greetings)
            }
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        GeneratedPluginRegistrant.registerWith(flutterEngine)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        flutterEngine?.dartExecutor?.let {
                MethodChannel(it, CHANNEL).apply {
                    val greeting = successNativeCode(intent)
                invokeMethod(InvokeMethod,greeting)
            }
        }
    }

    private fun successNativeCode(intent: Intent): String {
        val scheme = intent.scheme
        val mimeType = intent.type
        if (("http" == scheme || "https" == scheme || "file" == scheme || "content" == scheme)) {
            val uri = intent.data
            return uri.toString()
        }

        if (("text/html" == mimeType || "text/plain" == mimeType)) {
            val text = intent.getStringExtra(Intent.EXTRA_TEXT)
            return text ?: ""
        }
        return ""
    }

    companion object {
        private const val CHANNEL = "com.swan.shareData"
        private const val InvokeMethod = "shareData"
    }
}
