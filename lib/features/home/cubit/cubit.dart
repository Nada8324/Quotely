import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_nti/core/data/datasources/quotes_remote_datasource.dart';
import 'package:graduation_project_nti/core/data/models/quote_model.dart';

import 'states.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  final QuotesRemoteDataSource _dataSource = QuotesRemoteDataSource();

  final List<String> _categories = const [
    'All',
    'Wisdom',
    'Philosophy',
    'Life',
    'Truth',
    'Inspirational',
    'Relationships',
    'Love',
    'Faith',
    'Humor',
    'Success',
    'Courage',
    'Happiness',
    'Art',
    'Writing',
    'Fear',
    'Nature',
    'Time',
    'Freedom',
    'Death',
    'Leadership',
  ];

  String _selectedCategory = 'All';
  List<QuoteModel> _quotes = [];
  Set<String> _favoriteIds = {};

  List<String> get categories => _categories;

  Future<void> loadInitialQuotes() async {
    if (_quotes.isNotEmpty) return;
    await fetchQuotes(refresh: true);
  }

  Future<void> fetchQuotes({required bool refresh}) async {
    emit(
      HomeLoading(selectedCategory: _selectedCategory, categories: _categories),
    );

    try {
      final quotes = await _dataSource.getQuotes(
        category: _selectedCategory,
        limit: 100,
      );
      // quotes.shuffle(Random());
      _quotes = quotes;

      emit(
        HomeSuccess(
          selectedCategory: _selectedCategory,
          categories: _categories,
          quotes: _quotes,
          favoriteIds: _favoriteIds,
        ),
      );
    } catch (_) {
      emit(
        HomeError(
          message: 'Failed to load quotes. Please try again.',
        ),
      );
    }
  }

  Future<void> changeCategory(String category) async {
    if (category == _selectedCategory) return;
    _selectedCategory = category;
    _quotes = [];
    emit(
      HomeLoading(selectedCategory: _selectedCategory, categories: _categories),
    );
    await fetchQuotes(refresh: true);
  }

  void toggleFavorite(String quoteId) {
    if (_favoriteIds.contains(quoteId)) {
      _favoriteIds.remove(quoteId);
    } else {
      _favoriteIds.add(quoteId);
    }

    emit(
      HomeSuccess(
        selectedCategory: _selectedCategory,
        categories: _categories,
        quotes: _quotes,
        favoriteIds: _favoriteIds,
      ),
    );
  }
}
