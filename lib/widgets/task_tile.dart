import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/model/tasks_model.dart';
import 'package:to_do_list/notifications/notifications_service.dart';
import 'package:to_do_list/providers/task_provider.dart';
import 'package:intl/intl.dart';
import 'package:to_do_list/screens/remaining_tasks.dart';
import 'package:to_do_list/utils/app_colors.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  const TaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final isCompleted = task.isCompleted;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: isCompleted ? colorScheme.surfaceVariant : colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Opacity(
        opacity: isCompleted ? 0.6 : 1.0,
        child: ListTile(
          leading: Checkbox(
            value: isCompleted,
            onChanged: !isCompleted
                ? (_) async {
                    final confirm = await showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text("Complete Task?"),
                        content: Text(
                            "Are you sure you want to mark ${task.title.toUpperCase().toString()} as completed?"),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: Text(
                                "Cancel",
                                style:
                                    TextStyle(color: AppColors.secondaryColor),
                              )),
                          ElevatedButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text(
                                "Complete",
                                style:
                                    TextStyle(color: AppColors.secondaryColor),
                              )),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      BCMNotification().cancel(task.id);
                      context
                          .read<TaskProvider>()
                          .toggleTaskCompletion(task.id);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TaskCompletedScreen(),
                        ),
                      );
                    }
                  }
                : null,
          ),
          title: Text(
            task.title,
            style: TextStyle(
              decoration: isCompleted ? TextDecoration.lineThrough : null,
              color: colorScheme.onSurface,
            ),
          ),
          subtitle: Text(
            DateFormat.yMMMd().format(task.dateTime),
            style: TextStyle(color: colorScheme.onSurface.withOpacity(0.7)),
          ),
          trailing: IconButton(
            icon: Icon(Icons.delete, color: colorScheme.error),
            onPressed: () => _showDeleteDialog(context),
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Task?"),
        content: Text(
            "Are you sure you want to delete \"${task.title.toUpperCase().toString()}\"?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              "Cancel",
              style: TextStyle(color: AppColors.secondaryColor),
            ),
          ),
          ElevatedButton(
            // style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            onPressed: () {
              context.read<TaskProvider>().deleteTask(task.id);
              Navigator.pop(ctx);
            },
            child: const Text(
              "Delete",
              style: TextStyle(color: AppColors.secondaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
