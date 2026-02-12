import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_nti/core/colors.dart';
import 'package:graduation_project_nti/core/data/models/favorite_model.dart';
import 'package:graduation_project_nti/core/data/models/quote_model.dart';
import 'package:graduation_project_nti/core/widgets/quote_card.dart';
import 'package:graduation_project_nti/features/favorites/cubit/cubit.dart';
import 'package:graduation_project_nti/features/favorites/cubit/states.dart';

class CollectionsView extends StatefulWidget {
  const CollectionsView({super.key});

  @override
  State<CollectionsView> createState() => _CollectionsViewState();
}

class _CollectionsViewState extends State<CollectionsView> {
  Future<void> _showCreateCollectionDialog(BuildContext context) async {
    final controller = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.lightOrange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('New Collection'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Collection name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await context.read<FavoritesCubit>().createCollection(
                  controller.text,
                );
                if (dialogContext.mounted) {
                  Navigator.of(dialogContext).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryOrange,
              ),
              child: const Text(
                'Create',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );

    Future.delayed(
      const Duration(milliseconds: 300),
      () => controller.dispose(),
    );
  }

  Future<void> _showAddToCollectionSheet(
    BuildContext context,
    FavoritesSuccess successState,
    FavoriteQuoteModel favorite,
  ) async {
    if (successState.collections.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please create a collection first.')),
      );
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add quote to collection',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                ...successState.collections.map((collection) {
                  final exists = collection.quoteIds.contains(favorite.quoteId);
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(collection.name),
                    subtitle: Text('${collection.quoteIds.length} quote(s)'),
                    trailing: Icon(
                      exists
                          ? Icons.check_circle_rounded
                          : Icons.add_circle_outline_rounded,
                      color: exists ? Colors.green : AppColors.primaryOrange,
                    ),
                    onTap: () async {
                      await context
                          .read<FavoritesCubit>()
                          .toggleQuoteInCollection(
                            collectionId: collection.id,
                            quoteId: favorite.quoteId,
                          );
                      if (sheetContext.mounted) {
                        Navigator.of(sheetContext).pop();
                      }
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateCollectionDialog(context),
        backgroundColor: AppColors.primaryOrange,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.create_new_folder_outlined),
        label: const Text('New Collection'),
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
          child: BlocConsumer<FavoritesCubit, FavoritesState>(
            listener: (context, state) {
              if (state is FavoritesFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is FavoritesLoading || state is FavoritesInitial) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is FavoritesFailure) {
                return Center(child: Text(state.message));
              }

              final successState = state as FavoritesSuccess;
              return ListView(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 90),
                children: [
                  const Center(
                    child: Text(
                      'Collections',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111827),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Center(
                    child: Text(
                      'Save your favorite quotes in beautiful collections',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Favorite Quotes (${successState.favorites.length})',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (successState.favorites.isEmpty)
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Text('No favorites yet.'),
                      ),
                    )
                  else
                    ...successState.favorites.map((favorite) {
                      final quoteModel = _quoteFromFavorite(favorite);
                      return Column(
                        children: [
                          QuoteCard(
                            quote: quoteModel,
                            fontSize: 18,
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
                            child: OutlinedButton.icon(
                              onPressed: () => _showAddToCollectionSheet(
                                context,
                                successState,
                                favorite,
                              ),
                              icon: const Icon(Icons.playlist_add_rounded),
                              label: const Text('Add to collection'),
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      );
                    }),
                  const SizedBox(height: 14),
                  Text(
                    'Your Collections (${successState.collections.length})',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (successState.collections.isEmpty)
                    const Card(
                      elevation: 2,
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Text('No collections yet.'),
                      ),
                    )
                  else
                    ...successState.collections.map((collection) {
                      final collectionFavorites = successState.favorites
                          .where(
                            (favorite) =>
                                collection.quoteIds.contains(favorite.quoteId),
                          )
                          .toList();

                      return Card(
                        elevation: 2,
                        color: Colors.white,
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      collection.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline),
                                    onPressed: () {
                                      context
                                          .read<FavoritesCubit>()
                                          .deleteCollection(collection.id);
                                    },
                                  ),
                                ],
                              ),
                              Text('${collection.quoteIds.length} quote(s)'),
                              const SizedBox(height: 8),
                              if (collectionFavorites.isEmpty)
                                const Text(
                                  'No quotes from favorites in this collection yet.',
                                )
                              else
                                ...collectionFavorites.map((favorite) {
                                  final quoteModel = _quoteFromFavorite(
                                    favorite,
                                  );
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: QuoteCard(
                                      quote: quoteModel,
                                      fontSize: 16,
                                      isFavorite: true,
                                      onToggleFavorite: (_) {
                                        context
                                            .read<FavoritesCubit>()
                                            .toggleFavorite(quoteModel);
                                      },
                                    ),
                                  );
                                }),
                            ],
                          ),
                        ),
                      );
                    }),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
