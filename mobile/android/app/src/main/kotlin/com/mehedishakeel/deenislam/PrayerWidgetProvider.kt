package com.mehedishakeel.deenislam

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews

class PrayerWidgetProvider : AppWidgetProvider() {
    companion object {
        const val PREFS_NAME = "DeenIslamWidgetPrefs"
        const val KEY_CITY = "widget_city"
        const val KEY_NEXT_WAQT = "widget_next_waqt"
        const val KEY_NEXT_TIME = "widget_next_time"
        const val KEY_HIJRI = "widget_hijri"

        fun updateAllWidgets(context: Context) {
            val manager = AppWidgetManager.getInstance(context)
            val componentName = ComponentName(context, PrayerWidgetProvider::class.java)
            val ids = manager.getAppWidgetIds(componentName)
            for (appWidgetId in ids) {
                updateAppWidget(context, manager, appWidgetId)
            }
        }

        private fun updateAppWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int
        ) {
            val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            val city = prefs.getString(KEY_CITY, "ঢাকা") ?: "ঢাকা"
            val nextWaqt = prefs.getString(KEY_NEXT_WAQT, "পরবর্তী সালাত") ?: "পরবর্তী সালাত"
            val nextTime = prefs.getString(KEY_NEXT_TIME, "--:--") ?: "--:--"
            val hijri = prefs.getString(KEY_HIJRI, "দ্বীন ইসলাম • আল-কুরআন ও সালাত") ?: "দ্বীন ইসলাম"

            val views = RemoteViews(context.packageName, R.layout.prayer_widget)
            views.setTextViewText(R.id.widget_city, "📍 $city")
            views.setTextViewText(R.id.widget_waqt_title, "পরবর্তী: $nextWaqt")
            views.setTextViewText(R.id.widget_waqt_time, nextTime)
            views.setTextViewText(R.id.widget_hijri_date, "🌙 $hijri")

            val intent = Intent(context, MainActivity::class.java)
            val pendingIntent = PendingIntent.getActivity(
                context,
                0,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.widget_root, pendingIntent)

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }
}
