import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/quote_model.dart';

class QuotesRemoteDataSource {
  Dio dio = Dio(
    BaseOptions(
      baseUrl: "https://api.api-ninjas.com/v2/",
      headers: {'X-Api-Key': dotenv.env['QUOTES_API_KEY'] ?? ""},
    ),
  );

  /// Random Quotes
  Future<List<QuoteModel>> getRandomQuotes({
    String? category,
    int? limit,
  }) async {
    List<QuoteModel> quotes = [];
    try {
      final queryParams = {
        if (category != null && category != 'All') 'categories': category,
        if (limit != null) 'limit': limit.toString(),
      };

      final response = await dio.get(
        'randomquotes',
        queryParameters: queryParams,
      );

      for (var element in response.data) {
        quotes.add(QuoteModel.fromJson(element));
      }
    } catch (e) {
      print('Error fetching random quotes: $e');
    }
    return quotes;
  }

  /// Get Quotes with filters
  Future<List<QuoteModel>> getQuotes({
    String? category,
    String? author,
    int? limit,
    int? offset,
  }) async {
    List<QuoteModel> quotes = [];
    try {
      final queryParams = <String, dynamic>{
        if (category != null && category != 'All')
          'categories': category.toLowerCase(),
        if (limit != null) 'limit': limit.toString(),
      };

      final response = await dio.get('quotes', queryParameters: queryParams);

      for (var element in response.data) {
        quotes.add(QuoteModel.fromJson(element));
      }
    } catch (e) {
      print('Error fetching quotes: $e');
    }
    return quotes;
  }

  /// Get quote of the day
  Future<QuoteModel?> getQuoteOfTheDay() async {
    try {
      final response = await dio.get('quoteoftheday');
      final data = response.data;

      return QuoteModel.fromJson(data[0]);
    } catch (e) {
      print('Error fetching quote of the day: $e');
    }

    return null;
  }
}
