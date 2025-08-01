import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:to_do_list/providers/selected_date_provider.dart';
import 'package:to_do_list/providers/task_provider.dart';
import 'package:to_do_list/utils/app_colors.dart';
import 'package:to_do_list/widgets/add_task_dialogue.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.secondaryColor.withOpacity(.5),
        title: const Text("Calendar"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Consumer2<TaskProvider, SelectedDateProvider>(
            builder: (context, taskProvider, dateProvider, _) {
              return TableCalendar(
                calendarFormat: CalendarFormat.month,
                availableCalendarFormats: const {
                  CalendarFormat.month: 'Month',
                },
                focusedDay: dateProvider.selectedDate,
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                selectedDayPredicate: (day) =>
                    isSameDay(day, dateProvider.selectedDate),
                onDaySelected: (selectedDay, focusedDay) {
                  dateProvider.setSelectedDate(selectedDay);
                },
                eventLoader: (day) {
                  return taskProvider
                      .tasksForDate(day)
                      .where((task) => !task.isCompleted)
                      .toList();
                },
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: AppColors.secondaryColor.withOpacity(.5),
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: AppColors.secondaryColor.withOpacity(.8),
                    shape: BoxShape.circle,
                  ),
                  markerDecoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  markersMaxCount: 1,
                ),
              );
            },
          ),
          Expanded(
            child: Consumer2<TaskProvider, SelectedDateProvider>(
              builder: (context, taskProvider, dateProvider, _) {
                final filteredTasks =
                    taskProvider.tasksForDate(dateProvider.selectedDate);

                if (filteredTasks.isEmpty) {
                  return const Center(child: Text("No tasks for this date"));
                }

                return ListView.builder(
                  itemCount: filteredTasks.length,
                  itemBuilder: (context, index) {
                    final task = filteredTasks[index];
                    return ListTile(
                      title: Text(task.title),
                      subtitle: Text(DateFormat.jm().format(task.dateTime)),
                      trailing: IconButton(
                        onPressed: () {
                          context
                              .read<TaskProvider>()
                              .toggleTaskCompletion(task.id);
                        },
                        icon: Icon(
                          task.isCompleted
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color:
                              task.isCompleted ? Colors.green : Colors.orange,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.secondaryColor.withOpacity(.5),
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => AddTaskDialog(
              initialDate: context.read<SelectedDateProvider>().selectedDate,
            ),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }
}
