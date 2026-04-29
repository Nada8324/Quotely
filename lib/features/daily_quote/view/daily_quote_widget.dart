import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project_nti/core/colors.dart';
import 'package:graduation_project_nti/core/services/daily_quote_home_widget_service.dart';
import 'package:graduation_project_nti/features/daily_quote/cubit/cubit.dart';
import 'package:graduation_project_nti/features/daily_quote/cubit/state.dart';

class DailyView extends StatelessWidget {
  const DailyView({super.key});

  String _todayLabel() {
    final now = DateTime.now();
    const weekDays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${weekDays[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}, ${now.year}';
  }

  Future<void> _addWidgetToHome(BuildContext context) async {
    final requested = await DailyQuoteHomeWidgetService.requestPinWidget();
    if (!context.mounted) return;

    if (requested) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Choose where to place the widget.')),
      );
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add Widget Manually'),
        content: const Text(
          'Long-press on home screen, choose Widgets, then select Quotely Daily Quote widget.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
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

              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(16.r),
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 18.r,
                        color: Colors.grey[700],
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          _todayLabel(),
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Quote of the Day',
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF111827),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Container(
                    padding: EdgeInsets.all(20.r),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.lightOrange, Colors.white],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Today\'s inspiration',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryOrange,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          '"${quote.quote}"',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          '- ${quote.author}',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _addWidgetToHome(context),
                      icon: const Icon(Icons.add_home_work_outlined),
                      label: const Text('Add Daily Quote Widget'),
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
}
