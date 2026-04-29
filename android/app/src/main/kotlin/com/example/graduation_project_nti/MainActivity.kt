package com.example.graduation_project_nti

import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channelName = "daily_quote_widget"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "refreshWidget" -> {
                        refreshDailyQuoteWidget()
                        result.success(true)
                    }
                    "requestPinWidget" -> {
                        result.success(requestPinWidget())
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun refreshDailyQuoteWidget() {
        val appWidgetManager = getSystemService(Context.APPWIDGET_SERVICE) as AppWidgetManager
        val componentName = ComponentName(this, DailyQuoteWidgetProvider::class.java)
        val widgetIds = appWidgetManager.getAppWidgetIds(componentName)

        if (widgetIds.isNotEmpty()) {
            DailyQuoteWidgetProvider.updateWidgets(this, appWidgetManager, widgetIds)
        }
    }

    private fun requestPinWidget(): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return false

        val appWidgetManager = getSystemService(Context.APPWIDGET_SERVICE) as AppWidgetManager
        if (!appWidgetManager.isRequestPinAppWidgetSupported) return false

        val componentName = ComponentName(this, DailyQuoteWidgetProvider::class.java)
        return appWidgetManager.requestPinAppWidget(componentName, null, null)
    }
}
