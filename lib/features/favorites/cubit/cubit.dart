import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_nti/core/data/datasources/favorites_remote_ds.dart';
import 'package:graduation_project_nti/core/data/models/collection_model.dart';
import 'package:graduation_project_nti/core/data/models/favorite_model.dart';
import 'package:graduation_project_nti/core/data/models/quote_model.dart';
import 'package:graduation_project_nti/features/favorites/cubit/states.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit() : super(FavoritesInitial());

  final FavoritesRemoteDataSource _remote = FavoritesRemoteDataSource();

  StreamSubscription? _favoritesSubscription;
  StreamSubscription? _collectionsSubscription;

  void startWatching() {
    if (_favoritesSubscription != null || _collectionsSubscription != null) {
      return;
    }

    emit(FavoritesLoading());

    _favoritesSubscription = _remote.watchFavorites().listen(
      (favorites) {
        final List<QuoteCollectionModel> currentCollections =
            state is FavoritesSuccess
            ? (state as FavoritesSuccess).collections
            : const [];

        emit(
          FavoritesSuccess(
            favorites: favorites,
            collections: currentCollections,
          ),
        );
      },
      onError: (_) {
        emit(FavoritesFailure('Could not load favorites.'));
      },
    );

    _collectionsSubscription = _remote.watchCollections().listen(
      (collections) {
        final List<FavoriteQuoteModel> currentFavorites =
            state is FavoritesSuccess
            ? (state as FavoritesSuccess).favorites
            : const [];

        emit(
          FavoritesSuccess(
            favorites: currentFavorites,
            collections: collections,
          ),
        );
      },
      onError: (e) {
        emit(FavoritesFailure('Could not load collections. $e'));
      },
    );
  }

  Future<void> toggleFavorite(QuoteModel quote) async {
    try {
      await _remote.toggleFavorite(quote);
    } catch (_) {
      emit(FavoritesFailure('Could not update favorite.'));
    }
  }

  Future<void> createCollection(String name) async {
    if (name.trim().isEmpty) return;

    try {
      await _remote.createCollection(name.trim());
    } catch (_) {
      emit(FavoritesFailure('Could not create collection.'));
    }
  }

  Future<void> deleteCollection(String collectionId) async {
    try {
      await _remote.deleteCollection(collectionId);
    } catch (_) {
      emit(FavoritesFailure('Could not delete collection.'));
    }
  }

  Future<void> toggleQuoteInCollection({
    required String collectionId,
    required String quoteId,
  }) async {
    try {
      await _remote.toggleQuoteInCollection(
        collectionId: collectionId,
        quoteId: quoteId,
      );
    } catch (_) {
      emit(FavoritesFailure('Could not update collection.'));
    }
  }

  @override
  Future<void> close() async {
    await _favoritesSubscription?.cancel();
    await _collectionsSubscription?.cancel();
    return super.close();
  }
}
