import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_nti/core/data/datasources/quotes_remote_datasource.dart';
import 'package:graduation_project_nti/features/daily_quote/cubit/state.dart';

class DailyQuoteCubit extends Cubit<DailyQuoteState> {
  DailyQuoteCubit() : super(DailyQuoteInitial());
  QuotesRemoteDataSource remote = QuotesRemoteDataSource();

  Future<void> loadQuoteOfTheDay({bool forceRefresh = false}) async {
    emit(DailyQuoteLoading());

    try {
      final quote = await remote.getQuoteOfTheDay();

      if (quote == null) {
        emit(DailyQuoteError(message: 'Unable to load today\'s quote.'));
        return;
      }

      emit(DailyQuoteLoaded(quote: quote));
    } catch (e) {
      emit(
        DailyQuoteError(
          message: 'Failed to load quote of the day.',
        ),
      );
    }
  }
}
