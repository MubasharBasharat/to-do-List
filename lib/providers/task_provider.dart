import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:to_do_list/model/tasks_model.dart';
import 'package:to_do_list/notifications/notifications_service.dart';

class TaskProvider extends ChangeNotifier {
  late Box<Task> _taskBox;
  final notify = BCMNotification();
  int maxNotificationId = 2147483647;

  TaskProvider() {
    _taskBox = Hive.box<Task>('tasksBox'); // assumes box is already opened
  }

  List<Task> get tasks => _taskBox.values.toList();

  void addTask(Task task) {
    _taskBox.put(task.id.toString(), task);
    // ✅ String key
    notify.scheduleNotification(
        id: task.id % maxNotificationId,
        title: task.title,
        body: task.title,
        scheduledDate: task.dateTime);
    notifyListeners();
  }

  void deleteTask(int id) async {
    await notify.cancel(id % maxNotificationId);
    _taskBox.delete(id.toString()); // ✅ String key
    notifyListeners();
  }

  void toggleTaskCompletion(int id) async {
    final task = _taskBox.get(id.toString()); // ✅ String key
    if (task != null) {
      final updatedTask = Task(
        id: task.id,
        title: task.title,
        isCompleted: !task.isCompleted,
        category: task.category,
        dateTime: task.dateTime,
        hasReminder: task.hasReminder,
      );
      _taskBox.put(id.toString(), updatedTask);
      // ✅ String key
      await notify.cancel(id % maxNotificationId);
      notifyListeners();
    }
  }

  List<Task> tasksByDate(DateTime date) {
    return tasks
        .where((task) =>
            task.dateTime.year == date.year &&
            task.dateTime.month == date.month &&
            task.dateTime.day == date.day)
        .toList();
  }

  List<Task> get completedTasks =>
      tasks.where((task) => task.isCompleted).toList();

  List<Task> tasksForDate(DateTime date) {
    return tasks.where((task) {
      final taskDate = task.dateTime;
      return taskDate.year == date.year &&
          taskDate.month == date.month &&
          taskDate.day == date.day;
    }).toList();
  }
}
