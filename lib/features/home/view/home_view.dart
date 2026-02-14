import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_nti/core/colors.dart';
import 'package:graduation_project_nti/core/data/models/quote_model.dart';
import 'package:graduation_project_nti/core/widgets/quote_card.dart';
import 'package:graduation_project_nti/core/widgets/shimmer_loading.dart';
import 'package:graduation_project_nti/features/favorites/cubit/cubit.dart';
import 'package:graduation_project_nti/features/favorites/cubit/states.dart';
import 'package:graduation_project_nti/features/home/cubit/cubit.dart';
import 'package:graduation_project_nti/features/home/cubit/states.dart';
import 'package:graduation_project_nti/features/home/widgets/home_header.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.lightOrange, Colors.white],
          ),
        ),
        child: SafeArea(
          child: BlocConsumer<HomeCubit, HomeState>(
            listener: (context, state) {
              if (state is HomeError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              final selectedCategory = _selectedCategoryFromState(state);
              final categories = _categoriesFromState(context, state);
              final quotes = _quotesFromState(state);
              final isLoading = state is HomeLoading;
              return Column(
                children: [
                  HomeHeader(
                    categories: categories,
                    selectedCategory: selectedCategory,
                  ),
                  Expanded(
                    child: isLoading && quotes.isEmpty
                        ? buildLoadingShimmer()
                        : RefreshIndicator(
                            backgroundColor: Colors.white,
                            color: AppColors.primaryOrange,
                            onRefresh: () =>
                                context.read<HomeCubit>().fetchQuotes(),
                            child: BlocBuilder<FavoritesCubit, FavoritesState>(
                              builder: (context, favoritesState) {
                                final Set<String> favoriteIds =
                                    favoritesState is FavoritesSuccess
                                    ? favoritesState.favoriteIds
                                    : {};

                                return ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  itemCount: quotes.length,
                                  itemBuilder: (context, index) {
                                    final quote = quotes[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      child: QuoteCard(
                                        quote: quote,
                                        fontSize: 18,
                                        isFavorite: favoriteIds.contains(
                                          quote.id,
                                        ),
                                        onToggleFavorite: (_) {
                                          context
                                              .read<FavoritesCubit>()
                                              .toggleFavorite(quote);
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  String _selectedCategoryFromState(HomeState state) {
    if (state is HomeLoading) return state.selectedCategory;
    if (state is HomeSuccess) return state.selectedCategory;
    return 'All';
  }

  List<String> _categoriesFromState(BuildContext context, HomeState state) {
    if (state is HomeLoading) return state.categories;
    if (state is HomeSuccess) return state.categories;
    return [];
  }

  List<QuoteModel> _quotesFromState(HomeState state) {
    if (state is HomeSuccess) return state.quotes;
    return const [];
  }
}
