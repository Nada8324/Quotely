import 'package:graduation_project_nti/core/data/models/quote_model.dart';

sealed class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {
  
}

class SearchSuccess extends SearchState {
  final String selectedCategory;
  final String keyword;
  final List<QuoteModel> quotes;

  SearchSuccess({
    required this.selectedCategory,
    required this.keyword,
    required this.quotes,
  });
}

class SearchFailure extends SearchState {
  final String message;


  SearchFailure({
    required this.message,
  
  });
}
