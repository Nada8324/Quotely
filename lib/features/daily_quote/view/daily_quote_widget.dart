import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_nti/core/colors.dart';
import 'package:graduation_project_nti/features/daily_quote/cubit/cubit.dart';
import 'package:graduation_project_nti/features/daily_quote/cubit/state.dart';

class DailyView extends StatelessWidget {
  const DailyView({super.key});

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
          child: BlocConsumer<DailyQuoteCubit, DailyQuoteState>(
            listener: (context, state) {
              if (state is DailyQuoteError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              final quote = state is DailyQuoteLoaded ? state.quote : null;

              if (state is DailyQuoteLoading && quote == null) {
                return const Center(child: CircularProgressIndicator());
              }

              if (quote == null) {
                return Center(
                  child: ElevatedButton(
                    onPressed: () =>
                        context.read<DailyQuoteCubit>().loadQuoteOfTheDay(),
                    child: const Text('Retry'),
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () => context
                    .read<DailyQuoteCubit>()
                    .loadQuoteOfTheDay(forceRefresh: true),
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Text(
                      'Quote of the Day',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.lightOrange, Colors.white],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Today\'s inspiration',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryOrange,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '“${quote.quote}”',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '— ${quote.author}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
