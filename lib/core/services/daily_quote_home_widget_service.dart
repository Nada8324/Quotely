import 'package:flutter/services.dart';
import 'package:graduation_project_nti/core/data/models/quote_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DailyQuoteHomeWidgetService {
  DailyQuoteHomeWidgetService._();

  static const MethodChannel _channel = MethodChannel('daily_quote_widget');

  static const String _quoteKey = 'daily_quote_widget_quote';
  static const String _authorKey = 'daily_quote_widget_author';
  static const String _dateKey = 'daily_quote_widget_date';

  static Future<void> syncQuote(QuoteModel quote) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_quoteKey, quote.quote);
    await prefs.setString(_authorKey, quote.author);
    await prefs.setString(_dateKey, _formatDate(DateTime.now()));
    await refreshWidget();
  }

  static Future<void> refreshWidget() async {
    try {
      await _channel.invokeMethod<void>('refreshWidget');
    } catch (_) {}
  }

  static Future<bool> requestPinWidget() async {
    try {
      final result = await _channel.invokeMethod<bool>('requestPinWidget');
      return result ?? false;
    } catch (_) {
      return false;
    }
  }

  static String _formatDate(DateTime dateTime) {
    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    return '${dateTime.year}-$month-$day';
  }
}
