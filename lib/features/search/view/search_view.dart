import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_nti/core/colors.dart';
import 'package:graduation_project_nti/core/data/models/quote_model.dart';
import 'package:graduation_project_nti/core/widgets/quote_card.dart';
import 'package:graduation_project_nti/core/widgets/shimmer_loading.dart';
import 'package:graduation_project_nti/features/favorites/cubit/cubit.dart';
import 'package:graduation_project_nti/features/favorites/cubit/states.dart';
import 'package:graduation_project_nti/features/search/cubit/cubit.dart';
import 'package:graduation_project_nti/features/search/cubit/states.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<QuoteModel> _filteredQuotes(
    List<QuoteModel> quotes,
    String keywordValue,
  ) {
    final keyword = keywordValue.trim().toLowerCase();
    if (keyword.isEmpty) return quotes;

    return quotes.where((quote) {
      return quote.quote.toLowerCase().contains(keyword) ||
          quote.author.toLowerCase().contains(keyword);
    }).toList();
  }

  
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
          child: BlocConsumer<SearchCubit, SearchState>(
            listener: (context, state) {
              if (state is SearchFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              final keyword = _keywordFromState(state);
              final selectedCategory = _selectedCategoryFromState(state);
              final categories = _categoriesFromState(state);
              final showFilters = _showFiltersFromState(state);
              final quotes = _quotesFromState(state);
              final filteredQuotes = _filteredQuotes(quotes, keyword);
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Search Quotes',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: searchController,
                                onChanged: context
                                    .read<SearchCubit>()
                                    .updateKeyword,
                                decoration: InputDecoration(
                                  hintText: 'Search by quote or author...',
                                  prefixIcon: const Icon(Icons.search),
                                  suffixIcon: keyword.isEmpty
                                      ? null
                                      : IconButton(
                                          icon: const Icon(Icons.close),
                                          onPressed: () {
                                            searchController.clear();
                                            context
                                                .read<SearchCubit>()
                                                .clearSearch();
                                          },
                                        ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: context
                                  .read<SearchCubit>()
                                  .toggleFilters,
                              icon: Icon(
                                LucideIcons.listFilter,
                                color: showFilters
                                    ? AppColors.primaryOrange
                                    : Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        if (showFilters) ...[
                          const SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            value: selectedCategory,
                            decoration: InputDecoration(
                              labelText: 'Category',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            items: categories
                                .map(
                                  (category) => DropdownMenuItem(
                                    value: category,
                                    child: Text(category),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              if (value == null) return;
                              context.read<SearchCubit>().changeCategory(value);
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                  Expanded(
                    child: state is SearchLoading && quotes.isEmpty
                        ? buildLoadingShimmer()
                        : filteredQuotes.isEmpty
                        ? const Center(
                            child: Text(
                              'No quotes found.',
                              style: TextStyle(color: Color(0xFF6B7280)),
                            ),
                          )
                        : BlocBuilder<FavoritesCubit, FavoritesState>(
                            builder: (context, favoritesState) {
                              final favoriteIds =
                                  favoritesState is FavoritesSuccess
                                  ? favoritesState.favoriteIds
                                  : <String>{};

                              return RefreshIndicator(
                                onRefresh: () =>
                                    context.read<SearchCubit>().fetchQuotes(10),
                                child: ListView.builder(
                                  padding: const EdgeInsets.fromLTRB(
                                    16,
                                    4,
                                    16,
                                    90,
                                  ),
                                  itemCount: filteredQuotes.length,
                                  itemBuilder: (context, index) {
                                    final quote = filteredQuotes[index];
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 12,
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
                                ),
                              );
                            },
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

  String _keywordFromState(SearchState state) {
    if (state is SearchLoading) return state.keyword;
    if (state is SearchSuccess) return state.keyword;
    if (state is SearchFailure) return state.keyword;
    return '';
  }

  String _selectedCategoryFromState(SearchState state) {
    if (state is SearchLoading) return state.selectedCategory;
    if (state is SearchSuccess) return state.selectedCategory;
    if (state is SearchFailure) return state.selectedCategory;
    return 'All';
  }

  List<String> _categoriesFromState(SearchState state) {
    if (state is SearchLoading) return state.categories;
    if (state is SearchSuccess) return state.categories;
    if (state is SearchFailure) return state.categories;
    return const ['All'];
  }

  bool _showFiltersFromState(SearchState state) {
    if (state is SearchLoading) return state.showFilters;
    if (state is SearchSuccess) return state.showFilters;
    if (state is SearchFailure) return state.showFilters;
    return false;
  }

  List<QuoteModel> _quotesFromState(SearchState state) {
    if (state is SearchLoading) return state.quotes;
    if (state is SearchSuccess) return state.quotes;
    if (state is SearchFailure) return state.quotes;
    return const [];
  }
}
