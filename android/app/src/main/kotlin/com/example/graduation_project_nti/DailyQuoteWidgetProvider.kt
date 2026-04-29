package com.example.graduation_project_nti

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews

class DailyQuoteWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        updateWidgets(context, appWidgetManager, appWidgetIds)
    }

    companion object {
        private const val prefsName = "FlutterSharedPreferences"
        private const val quoteKey = "flutter.daily_quote_widget_quote"
        private const val authorKey = "flutter.daily_quote_widget_author"
        private const val dateKey = "flutter.daily_quote_widget_date"

        fun updateWidgets(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetIds: IntArray
        ) {
            val prefs = context.getSharedPreferences(prefsName, Context.MODE_PRIVATE)
            val quote = prefs.getString(quoteKey, "Open Quotely to load today's quote.") ?: ""
            val author = prefs.getString(authorKey, "Quotely") ?: "Quotely"
            val date = prefs.getString(dateKey, "") ?: ""

            appWidgetIds.forEach { appWidgetId ->
                val views = RemoteViews(context.packageName, R.layout.daily_quote_widget)
                views.setTextViewText(R.id.widget_quote, "\"$quote\"")
                views.setTextViewText(R.id.widget_author, "- $author")
                views.setTextViewText(R.id.widget_date, date)

                val launchIntent = Intent(context, MainActivity::class.java)
                val pendingIntent = PendingIntent.getActivity(
                    context,
                    appWidgetId,
                    launchIntent,
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                )
                views.setOnClickPendingIntent(R.id.widget_root, pendingIntent)

                appWidgetManager.updateAppWidget(appWidgetId, views)
            }
        }
    }
}
