import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_nti/core/colors.dart';
import 'package:graduation_project_nti/core/data/models/collection_model.dart';
import 'package:graduation_project_nti/core/data/models/favorite_model.dart';
import 'package:graduation_project_nti/core/data/models/quote_model.dart';
import 'package:graduation_project_nti/core/widgets/quote_card.dart';
import 'package:graduation_project_nti/features/favorites/cubit/cubit.dart';
import 'package:graduation_project_nti/features/favorites/cubit/states.dart';

class CollectionDetailsView extends StatelessWidget {
  final QuoteCollectionModel collection;
  final List<FavoriteQuoteModel> favorites;

  const CollectionDetailsView({
    super.key,
    required this.collection,
    required this.favorites,
  });

  QuoteModel _quoteFromFavorite(FavoriteQuoteModel favorite) {
    return QuoteModel(
      id: favorite.quoteId,
      quote: favorite.quote,
      author: favorite.author,
      work: '',
      categories: favorite.categories,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,

      appBar: AppBar(
        title: Text(collection.name),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.lightOrange, Colors.white],
          ),
        ),
        child: SafeArea(
          child: BlocBuilder<FavoritesCubit, FavoritesState>(
            builder: (context, state) {
              QuoteCollectionModel? currentCollection;
              if (state is FavoritesSuccess) {
                for (final item in state.collections) {
                  if (item.id == collection.id) {
                    currentCollection = item;
                    break;
                  }
                }
              }

              if (currentCollection == null) {
                return const Center(
                  child: Text(
                    'This collection no longer exists.',
                    style: TextStyle(color: Color(0xFF6B7280)),
                  ),
                );
              }

              final latestFavorites = state is FavoritesSuccess
                  ? state.favorites
                  : favorites;
              final collectionFavorites = latestFavorites
                  .where(
                    (favorite) =>
                        currentCollection!.quoteIds.contains(favorite.quoteId),
                  )
                  .toList();

              if (collectionFavorites.isEmpty) {
                return const Center(
                  child: Text(
                    'No quotes in this collection yet.',
                    style: TextStyle(color: Color(0xFF6B7280)),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: collectionFavorites.length,
                itemBuilder: (context, index) {
                  final favorite = collectionFavorites[index];
                  final quoteModel = _quoteFromFavorite(favorite);
                  return Column(
                    children: [
                      QuoteCard(
                        quote: quoteModel,
                        fontSize: 17,
                        isFavorite: true,
                        onToggleFavorite: (_) {
                          context.read<FavoritesCubit>().toggleFavorite(
                            quoteModel,
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () {
                            context
                                .read<FavoritesCubit>()
                                .toggleQuoteInCollection(
                                  collectionId: currentCollection!.id,
                                  quoteId: favorite.quoteId,
                                );
                          },
                          icon: const Icon(Icons.remove_circle_outline),
                          label: const Text('Remove from collection'),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
