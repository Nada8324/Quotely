
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graduation_project_nti/core/colors.dart';
import 'package:graduation_project_nti/features/main_screen/controller/bottom_nav_bar_controller.dart';

import 'package:lucide_icons/lucide_icons.dart';

class BottomNav extends StatelessWidget {
   final BottomNavController controller = Get.find();

  final navItems = const [
    {'icon': LucideIcons.home, 'label': 'Home'},
    {'icon': LucideIcons.search, 'label': 'Search'},
    {'icon': LucideIcons.quote, 'label': 'Daily'},
    {'icon': LucideIcons.folder, 'label': 'Collections'},
    {'icon': LucideIcons.user, 'label': 'Profile'},
  ];

 BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: navItems.asMap().entries.map((entry) {
            int index = entry.key;
            final item = entry.value;
            final isActive = controller.selectedIndex.value == index;

            return GestureDetector(
              onTap: () => controller.changeIndex(index),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    item['icon'] as IconData,
                    color: isActive ? AppColors.primaryOrange : const Color.fromARGB(225, 158, 158, 158),
                    size: 22,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item['label'] as String,
                    style: TextStyle(
                      fontSize: 12,
                      color: isActive ? AppColors.primaryOrange : Colors.grey,
                      fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
