import 'package:graduation_project_nti/core/data/models/quote_model.dart';

sealed class DailyQuoteState {}

class DailyQuoteInitial extends DailyQuoteState {}

class DailyQuoteLoading extends DailyQuoteState {}

class DailyQuoteLoaded extends DailyQuoteState {
  final QuoteModel quote;

  DailyQuoteLoaded({required this.quote});
}

class DailyQuoteError extends DailyQuoteState {
  final String message;

  DailyQuoteError({required this.message});
}
