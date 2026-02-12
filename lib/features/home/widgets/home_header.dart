import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_nti/core/colors.dart';
import 'package:graduation_project_nti/features/home/cubit/cubit.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.categories,
    required this.selectedCategory,
  });
  final List<String> categories;
  final String selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: const Text(
              'Quotely',
              style: TextStyle(fontSize: 35, fontWeight: .w600),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = selectedCategory == category;

                return InkWell(
                  onTap: () =>
                      context.read<HomeCubit>().changeCategory(category),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryOrange
                          : const Color.fromARGB(29, 191, 190, 190),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Center(
                      child: Text(
                        category,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
