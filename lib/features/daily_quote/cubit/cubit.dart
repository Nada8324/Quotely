import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_nti/core/data/models/quote_model.dart';
import 'package:graduation_project_nti/core/data/datasources/quotes_remote_datasource.dart';
import 'package:graduation_project_nti/core/services/daily_quote_home_widget_service.dart';
import 'package:graduation_project_nti/features/daily_quote/cubit/state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DailyQuoteCubit extends Cubit<DailyQuoteState> {
  DailyQuoteCubit() : super(DailyQuoteInitial());
  final QuotesRemoteDataSource remote = QuotesRemoteDataSource();

  static const String _cacheDateKey = 'daily_quote_cache_date';
  static const String _cachePayloadKey = 'daily_quote_cache_payload';

  Future<void> loadQuoteOfTheDay() async {
    if (isClosed) return;
    emit(DailyQuoteLoading());

    try {
      final today = _todayDateKey();
      final cachedToday = await _loadCachedQuote(forDate: today);
      if (cachedToday != null) {
        await DailyQuoteHomeWidgetService.syncQuote(cachedToday);
        if (isClosed) return;
        emit(DailyQuoteLoaded(quote: cachedToday));
        return;
      }

      final quote = await remote.getQuoteOfTheDay();

      if (quote == null) {
        final anyCachedQuote = await _loadCachedQuote();
        if (anyCachedQuote != null) {
          await DailyQuoteHomeWidgetService.syncQuote(anyCachedQuote);
          if (isClosed) return;
          emit(DailyQuoteLoaded(quote: anyCachedQuote));
          return;
        }
        if (isClosed) return;
        emit(DailyQuoteError(message: 'Unable to load today\'s quote.'));
        return;
      }

      await _cacheQuote(quote, forDate: today);
      await DailyQuoteHomeWidgetService.syncQuote(quote);
      if (isClosed) return;
      emit(DailyQuoteLoaded(quote: quote));
    } catch (e) {
      if (isClosed) return;
      emit(DailyQuoteError(message: 'Failed to load quote of the day.'));
    }
  }

  Future<void> _cacheQuote(QuoteModel quote, {required String forDate}) async {
    final prefs = await SharedPreferences.getInstance();
    final payload = jsonEncode({
      'id': quote.id,
      'quote': quote.quote,
      'author': quote.author,
      'work': quote.work,
      'categories': quote.categories,
    });

    await prefs.setString(_cacheDateKey, forDate);
    await prefs.setString(_cachePayloadKey, payload);
  }

  Future<QuoteModel?> _loadCachedQuote({String? forDate}) async {
    final prefs = await SharedPreferences.getInstance();
    final cachedDate = prefs.getString(_cacheDateKey);
    final cachedPayload = prefs.getString(_cachePayloadKey);

    if (cachedPayload == null) return null;
    if (forDate != null && cachedDate != forDate) return null;

    try {
      final decoded = jsonDecode(cachedPayload) as Map<String, dynamic>;
      return QuoteModel(
        id: (decoded['id'] ?? '').toString(),
        quote: (decoded['quote'] ?? '').toString(),
        author: (decoded['author'] ?? '').toString(),
        work: (decoded['work'] ?? '').toString(),
        categories: List<String>.from(decoded['categories'] ?? const []),
      );
    } catch (_) {
      return null;
    }
  }

  String _todayDateKey() {
    final now = DateTime.now();
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');
    return '${now.year}-$month-$day';
  }
}
