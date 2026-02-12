import 'package:graduation_project_nti/core/data/models/collection_model.dart';
import 'package:graduation_project_nti/core/data/models/favorite_model.dart';

sealed class FavoritesState {}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesSuccess extends FavoritesState {
  final List<FavoriteQuoteModel> favorites;
  final List<QuoteCollectionModel> collections;

  FavoritesSuccess({required this.favorites, required this.collections});

  Set<String> get favoriteIds => favorites.map((favorite) => favorite.quoteId).toSet();
}

class FavoritesFailure extends FavoritesState {
  final String message;

  FavoritesFailure(this.message);
}
