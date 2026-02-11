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

class HomeLoaded extends HomeState {
  final String selectedCategory;
  final List<String> categories;
  final List<QuoteModel> quotes;
  final Set<String> favoriteIds;

  HomeLoaded({
    required this.selectedCategory,
    required this.categories,
    required this.quotes,
    required this.favoriteIds,
  });
}

class HomeError extends HomeState {
  final String selectedCategory;
  final List<String> categories;
  final List<QuoteModel> quotes;
  final Set<String> favoriteIds;
  final String message;

  HomeError({
    required this.selectedCategory,
    required this.categories,
    required this.quotes,
    required this.favoriteIds,
    required this.message,
  });
}
