// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasks_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 1;

  @override
  Task read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Task(
      id: fields[0] as int,
      title: fields[1] as String,
      isCompleted: fields[2] as bool,
      category: fields[3] as TaskCategory,
      dateTime: fields[4] as DateTime,
      hasReminder: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.isCompleted)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.dateTime)
      ..writeByte(5)
      ..write(obj.hasReminder);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TaskCategoryAdapter extends TypeAdapter<TaskCategory> {
  @override
  final int typeId = 0;

  @override
  TaskCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TaskCategory.All;
      case 1:
        return TaskCategory.Personal;
      case 2:
        return TaskCategory.Work;
      case 3:
        return TaskCategory.Wishlist;
      case 4:
        return TaskCategory.Home;
      case 5:
        return TaskCategory.Health;
      default:
        return TaskCategory.All;
    }
  }

  @override
  void write(BinaryWriter writer, TaskCategory obj) {
    switch (obj) {
      case TaskCategory.All:
        writer.writeByte(0);
        break;
      case TaskCategory.Personal:
        writer.writeByte(1);
        break;
      case TaskCategory.Work:
        writer.writeByte(2);
        break;
      case TaskCategory.Wishlist:
        writer.writeByte(3);
        break;
      case TaskCategory.Home:
        writer.writeByte(4);
        break;
      case TaskCategory.Health:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
