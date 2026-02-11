import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_nti/features/daily_quote/view/daily_quote_widget.dart';
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
  var selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
            BlocProvider(
        create: (_) => HomeCubit()..loadInitialQuotes(),
        child: const HomeView(),
      ),
      const SearchView(),
      const DailyView(),
      const CollectionsView(),
      const ProfileView(),
    ];

    return Scaffold(
      body: IndexedStack(index: selectedIndex, children: pages),

      bottomNavigationBar: BottomNav(
        currentIndex: selectedIndex,
        onItemSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    );
  }
}
