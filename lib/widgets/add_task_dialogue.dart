import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/model/tasks_model.dart';
import 'package:to_do_list/notifications/notifications_service.dart';
import 'package:to_do_list/providers/task_provider.dart';
import 'package:to_do_list/utils/app_colors.dart';

class AddTaskDialog extends StatefulWidget {
  final DateTime? initialDate;
  const AddTaskDialog({super.key, this.initialDate});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final TextEditingController _titleController = TextEditingController();
  TaskCategory? _selectedCategory;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _setReminder = false;

  @override
  void initState() {
    // TODO: implement initState
    _selectedDate = widget.initialDate;

    super.initState();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
// final DateTime now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary:
                  AppColors.secondaryColor, // Header background & selected day
              onPrimary: Colors.white, // Text color on selected day
              onSurface: Colors.black, // Default text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor:
                    AppColors.secondaryColor, // Button (e.g., CANCEL, OK)
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary:
                  AppColors.secondaryColor, // Header background & selected day
              onPrimary: Colors.white, // Text color on selected day
              onSurface: Colors.black, // Default text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor:
                    AppColors.secondaryColor, // Button (e.g., CANCEL, OK)
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  void _submit() async {
    final title = _titleController.text.trim();
    if (title.isEmpty || _selectedCategory == null) return;
    final dateTime = (_selectedDate != null)
        ? DateTime(
            _selectedDate!.year,
            _selectedDate!.month,
            _selectedDate!.day,
            _selectedTime!.hour,
            _selectedTime!.minute,
          )
        : null;

    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch,
      title: title,
      isCompleted: false,
      category: _selectedCategory!,
      hasReminder: _setReminder,
      dateTime: dateTime!, // ✅ Required field
    );

    Provider.of<TaskProvider>(context, listen: false).addTask(newTask);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Task'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            TextField(
              cursorColor: AppColors.secondaryColor,
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Task Title',
                labelStyle: TextStyle(color: AppColors.secondaryColor),
                // enabledBorder: OutlineInputBorder(
                //   borderSide: BorderSide(color: AppColors.secondaryColor),
                // ),

                // Border when TextField is focused
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: AppColors.secondaryColor, width: 2.0),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Category Dropdown
            DropdownButtonFormField<TaskCategory>(
              value: _selectedCategory,
              hint: const Text('Select Category'),
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColors.secondaryColor, width: 2.0),
                  )),
              items: TaskCategory.values.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category.name),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedCategory = value),
            ),
            const SizedBox(height: 16),

            // Date Picker
            ListTile(
              title: const Text("Select Date"),
              subtitle: Text(_selectedDate == null
                  ? "No date chosen"
                  : _selectedDate!.toLocal().toString().split(" ")[0]),
              trailing: const Icon(Icons.calendar_month),
              onTap: _pickDate,
            ),

            // Time Picker
            ListTile(
              title: const Text("Select Time"),
              subtitle: Text(_selectedTime == null
                  ? "No time chosen"
                  : _selectedTime!.format(context)),
              trailing: const Icon(Icons.access_time),
              onTap: _pickTime,
            ),

            // Reminder Toggle
            if (_selectedTime != null)
              SwitchListTile(
                activeTrackColor: AppColors.secondaryColor,
                value: _setReminder,
                onChanged: (val) => setState(() => _setReminder = val),
                title: const Text("Set Reminder"),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppColors.secondaryColor.withOpacity(.5)),
            )),
        ElevatedButton(
            onPressed: _submit,
            child: Text(
              'Add',
              style: TextStyle(color: AppColors.secondaryColor.withOpacity(.5)),
            )),
      ],
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }
}
