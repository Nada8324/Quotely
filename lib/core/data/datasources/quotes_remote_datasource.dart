import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/quote_model.dart';

class QuotesRemoteDataSource {
  static const String _baseUrl = 'https://api.api-ninjas.com/v2/quotes';
  static final String? _apiKey = dotenv.env['QUOTES_API_KEY'];

  Future<List<QuoteModel>> getRandomQuotes({
    String? category,
    int? limit,
  }) async {
    final queryParameters = {
      if (category != null && category != 'All') 'categories': category,
      if (limit != null) 'limit': limit.toString(),
    };

    final uri = Uri.parse(
      'https://api.api-ninjas.com/v2/randomquotes',
    ).replace(queryParameters: queryParameters);

    final response = await http.get(uri, headers: {'X-Api-Key': _apiKey ?? ""});

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => QuoteModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load random quotes');
    }
  }

  Future<List<QuoteModel>> getQuotes({
    String? category,
    String? author,
    int? limit,
    int? offset,
  }) async {
    final queryParams = <String, String>{
      if (category != null && category != 'All')
        'categories': category.toLowerCase(),
      'author': ?author,
      if (limit != null) 'limit': limit.toString(),
      if (offset != null) 'offset': offset.toString(),
    };

    final uri = Uri.parse(_baseUrl).replace(queryParameters: queryParams);

    final response = await http.get(uri, headers: {'X-Api-Key': _apiKey ?? ""});

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => QuoteModel.fromJson(e)).toList();
    } else {
      throw Exception(
        'Failed to fetch quotes (status: ${response.statusCode})',
      );
    }
  }
}
