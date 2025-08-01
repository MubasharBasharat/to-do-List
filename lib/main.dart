import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/model/tasks_model.dart';
import 'package:to_do_list/notifications/notifications_service.dart';
import 'package:to_do_list/providers/calender_provider.dart';
import 'package:to_do_list/providers/selected_category.dart';
import 'package:to_do_list/providers/selected_date_provider.dart';
import 'package:to_do_list/providers/task_provider.dart';
import 'package:to_do_list/providers/theme_provider.dart';
import 'package:to_do_list/screens/home_screen.dart';
import 'package:to_do_list/screens/splash_screen.dart';

import 'package:to_do_list/screens/tasks.dart';
import 'package:to_do_list/screens/welcome_screen.dart';

import 'package:to_do_list/utils/app_colors.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void initializeTimeZones() {
  tz.initializeTimeZones();
  final String localTimeZone = tz.local.name;
  // $debugLog(localTimeZone);
  tz.setLocalLocation(tz.getLocation(localTimeZone));
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDir = await getApplicationDocumentsDirectory();
  Hive.init(appDir.path);

  Hive.registerAdapter(TaskCategoryAdapter());
  Hive.registerAdapter(TaskAdapter());
  // initializeTimeZones();

  await BCMNotification.initialize();

  // Test immediate notification
  BCMNotification().scheduleNotification(
      id: 1,
      title: "hello",
      body: "this is body",
      scheduledDate: DateTime.now().add(Duration(seconds: 10)));

  await Hive.openBox<Task>('tasksBox');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => SelectedCategoryProvider()),
        ChangeNotifierProvider(create: (_) => CalendarProvider()),
        ChangeNotifierProvider(create: (_) => SelectedDateProvider()),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
          child: const MyApp(),
        )
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To Do List',
      darkTheme: ThemeData.dark(),
      themeMode: context.watch<ThemeProvider>().themeMode,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
