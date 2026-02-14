import 'package:graduation_project_nti/core/data/models/quote_model.dart';

sealed class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {
  final String selectedCategory;
  final List<String> categories;
  final String keyword;
  final bool showFilters;
  final List<QuoteModel> quotes;

  SearchLoading({
    required this.selectedCategory,
    required this.categories,
    required this.keyword,
    required this.showFilters,
    required this.quotes,
  });
}

class SearchSuccess extends SearchState {
  final String selectedCategory;
  final List<String> categories;
  final String keyword;
  final bool showFilters;
  final List<QuoteModel> quotes;

  SearchSuccess({
    required this.selectedCategory,
    required this.categories,
    required this.keyword,
    required this.showFilters,
    required this.quotes,
  });
}

class SearchFailure extends SearchState {
  final String message;
  final String selectedCategory;
  final List<String> categories;
  final String keyword;
  final bool showFilters;
  final List<QuoteModel> quotes;

  SearchFailure({
    required this.message,
    required this.selectedCategory,
    required this.categories,
    required this.keyword,
    required this.showFilters,
    required this.quotes,
  });
}
