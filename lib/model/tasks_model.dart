import 'package:hive/hive.dart';

part 'tasks_model.g.dart'; // Required for Hive code generation

// @HiveType(typeId: 0)
// enum TaskCategory {
//   @HiveField(0)
//   All,
//   @HiveField(1)
//   health,
//   @HiveField(2)
//   personal,
//   @HiveField(3)
//   work,
//   @HiveField(4)
//   home,
// }
@HiveType(typeId: 0)
enum TaskCategory {
  @HiveField(0)
  All,
  @HiveField(1)
  Personal,
  @HiveField(2)
  Work,
  @HiveField(3)
  Wishlist,
  @HiveField(4)
  Home,
  @HiveField(5)
  Health,
}

@HiveType(typeId: 1)
class Task extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  bool isCompleted;

  @HiveField(3)
  final TaskCategory category;

  @HiveField(4)
  final DateTime dateTime;

  @HiveField(5)
  final bool hasReminder;

  Task({
    required this.id,
    required this.title,
    required this.isCompleted,
    required this.category,
    required this.dateTime,
    this.hasReminder = false,
  });
}
