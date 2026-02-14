import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_nti/core/colors.dart';
import 'package:graduation_project_nti/core/data/models/favorite_model.dart';
import 'package:graduation_project_nti/core/data/models/quote_model.dart';
import 'package:graduation_project_nti/core/widgets/quote_card.dart';
import 'package:graduation_project_nti/core/widgets/show_confirmation_dialog.dart';
import 'package:graduation_project_nti/features/favorites/cubit/cubit.dart';
import 'package:graduation_project_nti/features/favorites/cubit/states.dart';
import 'package:graduation_project_nti/features/favorites/view/collection_details_view.dart';
import 'package:lucide_icons/lucide_icons.dart';

class FavoritesView extends StatefulWidget {
  const FavoritesView({super.key});

  @override
  State<FavoritesView> createState() => _FavoriteViewState();
}

class _FavoriteViewState extends State<FavoritesView> {
  Future<void> showCreateCollectionDialog(BuildContext context) async {
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
                if (dialogContext.mounted) Navigator.of(dialogContext).pop();
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

  Future<void> showAddToCollectionSheet(
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
                    onTap: () {
                      context.read<FavoritesCubit>().toggleQuoteInCollection(
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

  QuoteModel quoteFromFavorite(FavoriteQuoteModel favorite) {
    return QuoteModel(
      id: favorite.quoteId,
      quote: favorite.quote,
      author: favorite.author,
      work: '',
      categories: favorite.categories,
    );
  }

  bool isInAnyCollection(FavoritesSuccess state, String quoteId) {
    for (final collection in state.collections) {
      if (collection.quoteIds.contains(quoteId)) return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showCreateCollectionDialog(context),
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

              if (state is FavoritesSuccess) {
                return ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
                  children: [
                    const Center(
                      child: Text(
                        'Favorites',
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
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Favorite Quotes (${state.favorites.length})',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (state.favorites.isEmpty)
                      const Card(
                        color: Colors.white,

                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Text('No favorites yet.'),
                        ),
                      )
                    else
                      ...state.favorites.map((favorite) {
                        final QuoteModel quoteModel = quoteFromFavorite(
                          favorite,
                        );
                        final bool inCollection = isInAnyCollection(
                          state,
                          favorite.quoteId,
                        );

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
                            const SizedBox(height: 5),
                            Align(
                              alignment: Alignment.centerRight,
                              child: inCollection
                                  ? const Chip(
                                      avatar: Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                        size: 18,
                                      ),
                                      label: Text('Added to collection'),
                                    )
                                  : OutlinedButton.icon(
                                      onPressed: () => showAddToCollectionSheet(
                                        context,
                                        state,
                                        favorite,
                                      ),
                                      icon: const Icon(
                                        Icons.playlist_add_rounded,
                                        color: AppColors.primaryOrange,
                                      ),
                                      label: const Text(
                                        'Add to collection',
                                        style: TextStyle(
                                          color: AppColors.primaryOrange,
                                        ),
                                      ),
                                    ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        );
                      }),
                    const SizedBox(height: 14),
                    Text(
                      'Your Collections (${state.collections.length})',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (state.collections.isEmpty)
                      const Card(
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Text('No collections yet.'),
                        ),
                      )
                    else
                      GridView.builder(
                        itemCount: state.collections.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 1.2,
                            ),
                        itemBuilder: (context, index) {
                          final collection = state.collections[index];
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider.value(
                                    value: context.read<FavoritesCubit>(),
                                    child: CollectionDetailsView(
                                      collection: collection,
                                      favorites: state.favorites,
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.lightOrange,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: .start,

                                        children: [
                                          const Icon(
                                            LucideIcons.folderHeart,
                                            color: AppColors.primaryOrange,
                                            size: 30,
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            collection.name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            '${collection.quoteIds.length} quote(s)',
                                            style: const TextStyle(
                                              color: Color(0xFF6B7280),
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        LucideIcons.trash2,
                                        size: 30,
                                        color: Colors.red,
                                      ),
                                      onPressed: () async {
                                        final confirmed =
                                            await showConfirmationDialog(
                                              context: context,
                                              title: 'Delete Collection',
                                              content:
                                                  'Are you sure you want to delete this collection?',
                                              confirmText: 'Delete',
                                              cancelText: 'Cancel',
                                            );

                                        if (confirmed) {
                                          context
                                              .read<FavoritesCubit>()
                                              .deleteCollection(collection.id);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                );
              }
              return SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
