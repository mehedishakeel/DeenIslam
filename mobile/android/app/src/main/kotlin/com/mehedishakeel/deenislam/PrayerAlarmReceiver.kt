package com.mehedishakeel.deenislam

import android.app.AlarmManager
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.media.AudioAttributes
import android.media.RingtoneManager
import android.os.Build
import android.os.PowerManager
import androidx.core.app.NotificationCompat
import org.json.JSONArray
import org.json.JSONObject

class PrayerAlarmReceiver : BroadcastReceiver() {
    companion object {
        const val CHANNEL_ID = "deenislam_prayer_alarm_v2"
        const val PREFS_NAME = "DeenIslamAlarmPrefs"
        const val KEY_SAVED_ALARMS = "saved_alarms_json"

        const val EXTRA_ID = "alarm_id"
        const val EXTRA_TITLE = "alarm_title"
        const val EXTRA_BODY = "alarm_body"
        const val EXTRA_TRIGGER_MILLIS = "alarm_trigger_millis"
        const val EXTRA_REPEAT_DAILY = "alarm_repeat_daily"

        private const val ONE_DAY_MILLIS = 86_400_000L

        fun saveAlarmEntry(
            context: Context,
            id: Int,
            triggerAtMillis: Long,
            title: String,
            body: String,
            repeatDaily: Boolean
        ) {
            val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            val arr = try {
                JSONArray(prefs.getString(KEY_SAVED_ALARMS, "[]") ?: "[]")
            } catch (_: Exception) {
                JSONArray()
            }

            val updated = JSONArray()
            for (i in 0 until arr.length()) {
                val obj = arr.optJSONObject(i) ?: continue
                if (obj.optInt("id", -1) != id) {
                    updated.put(obj)
                }
            }

            updated.put(
                JSONObject().apply {
                    put("id", id)
                    put("triggerAtMillis", triggerAtMillis)
                    put("title", title)
                    put("body", body)
                    put("repeatDaily", repeatDaily)
                }
            )
            prefs.edit().putString(KEY_SAVED_ALARMS, updated.toString()).apply()
        }

        fun removeAlarmEntries(context: Context, ids: List<Int>) {
            val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            val arr = try {
                JSONArray(prefs.getString(KEY_SAVED_ALARMS, "[]") ?: "[]")
            } catch (_: Exception) {
                return
            }

            val idSet = ids.toSet()
            val updated = JSONArray()
            for (i in 0 until arr.length()) {
                val obj = arr.optJSONObject(i) ?: continue
                if (!idSet.contains(obj.optInt("id", -1))) {
                    updated.put(obj)
                }
            }
            prefs.edit().putString(KEY_SAVED_ALARMS, updated.toString()).apply()
        }

        fun scheduleAlarmExact(
            context: Context,
            id: Int,
            triggerAtMillis: Long,
            title: String,
            body: String,
            repeatDaily: Boolean
        ): Boolean {
            if (triggerAtMillis <= System.currentTimeMillis()) return false
            val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as? AlarmManager ?: return false

            val alarmIntent = Intent(context, PrayerAlarmReceiver::class.java).apply {
                putExtra(EXTRA_ID, id)
                putExtra(EXTRA_TITLE, title)
                putExtra(EXTRA_BODY, body)
                putExtra(EXTRA_TRIGGER_MILLIS, triggerAtMillis)
                putExtra(EXTRA_REPEAT_DAILY, repeatDaily)
            }
            val pendingIntent = PendingIntent.getBroadcast(
                context,
                id,
                alarmIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )

            val launchIntent = Intent(context, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            }
            val showIntent = PendingIntent.getActivity(
                context,
                0,
                launchIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )

            val canExact = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                alarmManager.canScheduleExactAlarms()
            } else {
                true
            }

            try {
                if (canExact) {
                    // setAlarmClock bypasses Doze and OEM background restrictions reliably
                    val info = AlarmManager.AlarmClockInfo(triggerAtMillis, showIntent)
                    alarmManager.setAlarmClock(info, pendingIntent)
                } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    alarmManager.setAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, triggerAtMillis, pendingIntent)
                } else {
                    alarmManager.set(AlarmManager.RTC_WAKEUP, triggerAtMillis, pendingIntent)
                }
                if (repeatDaily) {
                    saveAlarmEntry(context, id, triggerAtMillis, title, body, true)
                }
                return true
            } catch (_: SecurityException) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    alarmManager.setAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, triggerAtMillis, pendingIntent)
                } else {
                    alarmManager.set(AlarmManager.RTC_WAKEUP, triggerAtMillis, pendingIntent)
                }
                return true
            } catch (_: Exception) {
                return false
            }
        }

        fun rescheduleAllSavedAlarms(context: Context) {
            val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            val arr = try {
                JSONArray(prefs.getString(KEY_SAVED_ALARMS, "[]") ?: "[]")
            } catch (_: Exception) {
                return
            }

            val now = System.currentTimeMillis()
            for (i in 0 until arr.length()) {
                val obj = arr.optJSONObject(i) ?: continue
                if (!obj.optBoolean("repeatDaily", true)) continue

                val id = obj.optInt("id", -1)
                if (id < 0) continue
                var triggerAt = obj.optLong("triggerAtMillis", 0L)
                if (triggerAt <= 0L) continue

                while (triggerAt <= now) {
                    triggerAt += ONE_DAY_MILLIS
                }
                val title = obj.optString("title", "সালাতের সময় হয়েছে")
                val body = obj.optString("body", "হাইয়্যা আলাস সালাহ — নামাজের প্রস্তুতি নিন।")
                scheduleAlarmExact(context, id, triggerAt, title, body, true)
            }
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        val powerManager = context.getSystemService(Context.POWER_SERVICE) as? PowerManager
        val wakeLock = powerManager?.newWakeLock(
            PowerManager.PARTIAL_WAKE_LOCK,
            "deenislam:PrayerAlarmWakeLock"
        )
        try {
            wakeLock?.acquire(15_000L)
            val id = intent.getIntExtra(EXTRA_ID, 1001)
            val title = intent.getStringExtra(EXTRA_TITLE) ?: "সালাতের সময় হয়েছে"
            val body = intent.getStringExtra(EXTRA_BODY) ?: "হাইয়্যা আলাস সালাহ — নামাজের প্রস্তুতি নিন।"
            val prevTrigger = intent.getLongExtra(EXTRA_TRIGGER_MILLIS, System.currentTimeMillis())
            val repeatDaily = intent.getBooleanExtra(EXTRA_REPEAT_DAILY, false)

            showPrayerNotification(context, id, title, body)

            if (repeatDaily) {
                var nextTrigger = prevTrigger + ONE_DAY_MILLIS
                val now = System.currentTimeMillis()
                while (nextTrigger <= now) {
                    nextTrigger += ONE_DAY_MILLIS
                }
                scheduleAlarmExact(context, id, nextTrigger, title, body, true)
            }
        } finally {
            try {
                if (wakeLock?.isHeld == true) {
                    wakeLock.release()
                }
            } catch (_: Exception) {}
        }
    }

    fun showPrayerNotification(context: Context, id: Int, title: String, body: String) {
        val manager = context.getSystemService(Context.NOTIFICATION_SERVICE) as? NotificationManager ?: return
        val alarmSoundUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM)
            ?: RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val audioAttrs = AudioAttributes.Builder()
                .setUsage(AudioAttributes.USAGE_ALARM)
                .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                .build()

            val channel = NotificationChannel(
                CHANNEL_ID,
                "সালাত ও আজান অ্যালার্ম",
                NotificationManager.IMPORTANCE_HIGH
            ).apply {
                description = "দৈনিক ৫ ওয়াক্ত নামাজ এবং সেহরি-ইফতারের অ্যালার্ম নোটিফিকেশন"
                enableVibration(true)
                vibrationPattern = longArrayOf(0L, 500L, 250L, 500L, 250L, 500L)
                enableLights(true)
                lockscreenVisibility = Notification.VISIBILITY_PUBLIC
                if (alarmSoundUri != null) {
                    setSound(alarmSoundUri, audioAttrs)
                }
            }
            manager.createNotificationChannel(channel)
        }

        val launchIntent = Intent(context, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
        }
        val contentIntent = PendingIntent.getActivity(
            context,
            id,
            launchIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val builder = NotificationCompat.Builder(context, CHANNEL_ID)
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentTitle(title)
            .setContentText(body)
            .setStyle(NotificationCompat.BigTextStyle().bigText(body))
            .setCategory(NotificationCompat.CATEGORY_ALARM)
            .setPriority(NotificationCompat.PRIORITY_MAX)
            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
            .setVibrate(longArrayOf(0L, 500L, 250L, 500L, 250L, 500L))
            .setAutoCancel(true)
            .setContentIntent(contentIntent)

        if (alarmSoundUri != null) {
            builder.setSound(alarmSoundUri)
        }

        manager.notify(id, builder.build())
    }
}
