//import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_nti/core/data/datasources/quotes_remote_datasource.dart';
import 'package:graduation_project_nti/core/data/models/quote_model.dart';

import 'states.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  final QuotesRemoteDataSource _dataSource = QuotesRemoteDataSource();

  final List<String> categories = const [
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

  Future<void> loadInitialQuotes() async {
    if (_quotes.isNotEmpty) return;
    await fetchQuotes();
  }

  Future<void> fetchQuotes() async {
    emit(
      HomeLoading(selectedCategory: _selectedCategory, categories: categories),
    );

    try {
      _quotes = await _dataSource.getQuotes(
        category: _selectedCategory,
        limit: 100,
      );
      // _quotes.shuffle(Random());

      emit(
        HomeSuccess(
          selectedCategory: _selectedCategory,
          categories: categories,
          quotes: _quotes,
        ),
      );
    } catch (_) {
      emit(HomeError(message: 'Failed to load quotes. Please try again.'));
    }
  }

  Future<void> changeCategory(String category) async {
    if (category == _selectedCategory) return;
    _selectedCategory = category;
    _quotes = [];
    await fetchQuotes();
  }
}
