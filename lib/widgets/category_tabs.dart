import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/model/tasks_model.dart';
import 'package:to_do_list/providers/selected_category.dart';
import 'package:to_do_list/utils/app_colors.dart';

class CategoryTabs extends StatelessWidget {
  const CategoryTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final selected = context.watch<SelectedCategoryProvider>().selectedCategory;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Row(
        children: TaskCategory.values.map((category) {
          final isSelected = category == selected;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Text(category.name),
              selected: isSelected,
              selectedColor: AppColors.secondaryColor.withOpacity(.5),
              onSelected: (_) {
                context
                    .read<SelectedCategoryProvider>()
                    .selectCategory(category);
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
