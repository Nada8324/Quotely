import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_nti/core/data/datasources/quotes_remote_datasource.dart';
import 'package:graduation_project_nti/core/data/models/quote_model.dart';
import 'package:graduation_project_nti/features/search/cubit/states.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  final QuotesRemoteDataSource _remote = QuotesRemoteDataSource();

  String _selectedCategory = 'All';
  String _keyword = '';

  List<QuoteModel> _quotes = [];

  Future<void> loadInitialQuotes() async {
    if (_quotes.isNotEmpty) return;
    await fetchQuotes(10);
  }

  Future<void> fetchQuotes(int limit) async {
    emit(SearchLoading());

    try {
      _quotes = await _remote.getQuotes(
        category: _selectedCategory,
        limit: limit,
      );
      emit(
        SearchSuccess(
          selectedCategory: _selectedCategory,
          keyword: _keyword,
          quotes: _quotes,
        ),
      );
    } catch (_) {
      emit(
        SearchFailure(
          message: 'Failed to load search results.',
        ),
      );
    }
  }

  Future<void> changeCategory(String category) async {
    if (category == _selectedCategory) return;
    _selectedCategory = category;
    _quotes = [];
    emit(
      SearchSuccess(
        selectedCategory: _selectedCategory,
        keyword: _keyword,
        quotes: _quotes,
      ),
    );
    await fetchQuotes(100);
  }

  void updateKeyword(String keyword) {
    _keyword = keyword;
    emit(
      SearchSuccess(
        selectedCategory: _selectedCategory,
        keyword: _keyword,
        quotes: _quotes,
      ),
    );
  }

  void clearSearch() {
    _keyword = '';
    emit(
      SearchSuccess(
        selectedCategory: _selectedCategory,
        keyword: _keyword,
        quotes: _quotes,
      ),
    );
  }
}
