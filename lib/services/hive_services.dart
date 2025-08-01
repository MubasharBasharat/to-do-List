import 'package:hive/hive.dart';
import 'package:to_do_list/model/tasks_model.dart';

class HiveStorageService {
  final _taskBox = Hive.box<Task>('tasksBox');

  List<Task> getTasks() => _taskBox.values.toList();

  Future<void> addTask(Task task) async {
    await _taskBox.put(task.id, task);
  }

  Future<void> deleteTask(int id) async {
    await _taskBox.delete(id);
  }

  Future<void> updateTask(Task task) async {
    await _taskBox.put(task.id, task);
  }

  void clearAll() {
    _taskBox.clear();
  }
}
