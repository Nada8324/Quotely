import 'package:flutter/material.dart';
import 'package:graduation_project_nti/core/colors.dart';

import 'package:lucide_icons/lucide_icons.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemSelected;

  final List<Map<String, dynamic>> navItems = const [
    {'icon': LucideIcons.home, 'label': 'Home'},
    {'icon': LucideIcons.search, 'label': 'Search'},
    {'icon': LucideIcons.quote, 'label': 'Daily'},
    {'icon': LucideIcons.folder, 'label': 'Collections'},
    {'icon': LucideIcons.user, 'label': 'Profile'},
  ];

  const BottomNav({
    super.key,
    required this.currentIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: navItems.asMap().entries.map((entry) {
          int index = entry.key;
          final item = entry.value;
          final isActive = currentIndex == index;

          return GestureDetector(
            onTap: () => onItemSelected(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  item['icon'] as IconData,
                  color: isActive
                      ? AppColors.primaryOrange
                      : const Color.fromARGB(225, 158, 158, 158),
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
    );
  }
}
