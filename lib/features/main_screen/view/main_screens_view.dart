import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graduation_project_nti/features/daily_quote/view/daily_quote_widget.dart';
import 'package:graduation_project_nti/features/favorites/view/collections_view.dart';
import 'package:graduation_project_nti/features/home/view/home_view.dart';
import 'package:graduation_project_nti/features/auth/profile/view/profile_view.dart';
import 'package:graduation_project_nti/features/search/view/search_view.dart';
import '../controller/bottom_nav_bar_controller.dart';
import '../../../core/widgets/bottom_nav_bar.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final BottomNavController controller = Get.find<BottomNavController>();
    final List<Widget> pages = [
      const HomeView(),
      const SearchView(),
      const DailyView(),
      const CollectionsView(),
      const ProfileView(),
    ];

    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.selectedIndex.value,
          children: pages,
        ),
      ),

      bottomNavigationBar: BottomNav(),
    );
  }
}
