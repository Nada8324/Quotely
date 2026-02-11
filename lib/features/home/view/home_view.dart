import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_nti/core/colors.dart';
import 'package:graduation_project_nti/core/data/models/quote_model.dart';
import 'package:graduation_project_nti/core/widgets/quote_card.dart';
import 'package:graduation_project_nti/core/widgets/shimmer_loading.dart';
import 'package:graduation_project_nti/features/home/cubit/cubit.dart';
import 'package:graduation_project_nti/features/home/cubit/states.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 243, 243),
      body: BlocConsumer<HomeCubit, HomeState>(
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
              Container(
                color: Colors.white,
                padding: const EdgeInsets.only(
                  top: 48,
                  left: 16,
                  right: 16,
                  bottom: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Quotely', style: TextStyle(fontSize: 24)),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 48,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          final isSelected = selectedCategory == category;

                          return GestureDetector(
                            onTap: () {
                              context.read<HomeCubit>().changeCategory(
                                category,
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primaryOrange
                                    : const Color.fromARGB(29, 191, 190, 190),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Center(
                                child: Text(
                                  category,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: isLoading && quotes.isEmpty
                    ? buildLoadingShimmer()
                    : RefreshIndicator(
                        onRefresh: () async {
                          await context.read<HomeCubit>().fetchQuotes(
                            refresh: true,
                          );
                        },
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 8),
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
                                isFavorite:  favoriteState.favoriteIds.contains(quote.id),,
                                onToggleFavorite: context
                                    .read<HomeCubit>()
                                    .toggleFavorite,
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ],
          );
        },
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
    return context.read<HomeCubit>().categories;
  }

  List<QuoteModel> _quotesFromState(HomeState state) {
    if (state is HomeSuccess) return state.quotes;
    return const [];
  }

  Set<String> _favoriteIdsFromState(HomeState state) {
    if (state is HomeSuccess) return state.favoriteIds;
    return const {};
  }
}
