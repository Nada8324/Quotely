import 'package:graduation_project_nti/core/data/models/quote_model.dart';

sealed class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {
  final String selectedCategory;
  final List<String> categories;

  HomeLoading({
    required this.selectedCategory,
    required this.categories,
  });
}

class HomeSuccess extends HomeState {
  final String selectedCategory;
  final List<String> categories;
  final List<QuoteModel> quotes;

  HomeSuccess({
    required this.selectedCategory,
    required this.categories,
    required this.quotes,
  });
}

class HomeError extends HomeState { 
  final String message;

  HomeError({
    required this.message,
  });
}
