package com.example.break_time_reminder_app
import androidx.annotation.NonNull
import android.content.ContentResolver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.media.RingtoneManager
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.*



class MainActivity: FlutterActivity(){
   
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "alarm").setMethodCallHandler { call, result ->
        
            if ("getAlarmUri" == call.method) {
                result.success(RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM).toString())
            }
             if ("cancelAlarm" == call.method) {
                 cancelAlarm();
                    result.success("Alarm stopped");
            }
        }
    }

    private fun cancelAlarm(){
val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as android.app.NotificationManager
notificationManager.cancelAll()

    }

    
}
