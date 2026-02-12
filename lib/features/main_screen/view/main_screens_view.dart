import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_nti/features/daily_quote/view/daily_quote_widget.dart';
import 'package:graduation_project_nti/features/favorites/cubit/cubit.dart';
import 'package:graduation_project_nti/features/favorites/view/collections_view.dart';
import 'package:graduation_project_nti/features/home/cubit/cubit.dart';
import 'package:graduation_project_nti/features/home/view/home_view.dart';
import 'package:graduation_project_nti/features/profile/view/profile_view.dart';
import 'package:graduation_project_nti/features/search/view/search_view.dart';
import '../../../core/widgets/bottom_nav_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  static const List<Widget> _pages = [
    HomeView(),
    SearchView(),
    DailyView(),
    CollectionsView(),
    ProfileView(),
  ];
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => HomeCubit()..loadInitialQuotes()),
        BlocProvider(create: (_) => FavoritesCubit()..startWatching()),
      ],
      child: Scaffold(
        body: IndexedStack(index: _selectedIndex, children: _pages),
        bottomNavigationBar: BottomNav(
          currentIndex: _selectedIndex,
          onItemSelected: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}
