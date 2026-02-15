package com.impala.mumin

import android.content.Intent
import android.os.Bundle
import com.ryanheise.audioservice.AudioServiceActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : AudioServiceActivity() {
    private var channel: MethodChannel? = null
    private var launchedFromNotification = false

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        channel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.impala.mumin/notification_tap"
        )

        // If we were cold-started from a notification tap, notify Flutter
        // after the engine is ready
        if (launchedFromNotification) {
            channel?.invokeMethod("onNotificationTap", null)
            launchedFromNotification = false
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        // Detect if this is a cold start from notification tap
        // (intent has FLAG_ACTIVITY_LAUNCHED_FROM_HISTORY or is from media session)
        if (savedInstanceState == null && intent != null) {
            val action = intent.action
            if (action != null && action != Intent.ACTION_MAIN) {
                launchedFromNotification = true
            }
            // Also check if launched from media browser service notification
            if (intent.hasCategory(Intent.CATEGORY_LAUNCHER).not() && 
                intent.component != null) {
                launchedFromNotification = true
            }
        }
        super.onCreate(savedInstanceState)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        // This is called when the activity is already running and a new intent
        // arrives (e.g. from tapping the media notification).
        channel?.invokeMethod("onNotificationTap", null)
    }
}
