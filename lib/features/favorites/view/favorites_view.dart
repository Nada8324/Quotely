import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
              child: const Text('Create'),
            ),
          ],
        );
      },
    );

    Future.delayed(Duration(milliseconds: 300),() => controller.dispose(),);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites & Collections')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateCollectionDialog(context),
        child: const Icon(Icons.add),
      ),
      body: BlocConsumer<FavoritesCubit, FavoritesState>(
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
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Favorite Quotes (${successState.favorites.length})',
                style: Theme.of(context).textTheme.titleMedium,
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
                ...successState.favorites.map(
                  (favorite) => Card(
                    child: ListTile(
                      title: Text(
                        favorite.quote,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(favorite.author),
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              Text(
                'Collections (${successState.collections.length})',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              if (successState.collections.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Text('No collections yet.'),
                  ),
                )
              else
                ...successState.collections.map(
                  (collection) => Card(
                    child: ListTile(
                      title: Text(collection.name),
                      subtitle: Text('${collection.quoteIds.length} quote(s)'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () {
                          context.read<FavoritesCubit>().deleteCollection(
                            collection.id,
                          );
                        },
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
