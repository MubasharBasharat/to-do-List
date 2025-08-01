import 'package:flutter/material.dart';

import 'package:to_do_list/model/tasks_model.dart';

class SelectedCategoryProvider extends ChangeNotifier {
  TaskCategory _selectedCategory = TaskCategory.All;

  TaskCategory get selectedCategory => _selectedCategory;

  void selectCategory(TaskCategory category) {
    _selectedCategory = category;
    notifyListeners();
  }
}
