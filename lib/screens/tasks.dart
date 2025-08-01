import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'package:to_do_list/model/tasks_model.dart';
import 'package:to_do_list/providers/selected_category.dart';
import 'package:to_do_list/providers/task_provider.dart';
import 'package:to_do_list/providers/theme_provider.dart';
import 'package:to_do_list/utils/app_colors.dart';
import 'package:to_do_list/utils/drawer.dart';

import 'package:to_do_list/widgets/add_task_dialogue.dart';
import 'package:to_do_list/widgets/category_tabs.dart';
import 'package:to_do_list/widgets/task_tile.dart';

class Tasks extends StatelessWidget {
  const Tasks({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedCategory =
        context.watch<SelectedCategoryProvider>().selectedCategory;
    final tasksProvider = context.watch<TaskProvider>();

    final filteredTasks = selectedCategory == TaskCategory.All
        ? tasksProvider.tasks
        : tasksProvider.tasks
            .where((task) => task.category == selectedCategory)
            .toList();

    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        // leading: AppDrawer(),

        backgroundColor: AppColors.secondaryColor.withOpacity(.5),
        title: const Text('To-Do List'),
        centerTitle: true,
        // actions: []
      ),
      body: Column(
        children: [
          const CategoryTabs(),
          filteredTasks.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = filteredTasks[index];
                      return TaskTile(task: task);
                    },
                  ),
                )
              : Column(
                  children: [
                    Image.asset("assets/noTasks.png"),
                    Text(
                      "No Tasks Yet!",
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.secondaryColor.withOpacity(.5),
        onPressed: () {
          showDialog(context: context, builder: (_) => const AddTaskDialog());
        },
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }
}
