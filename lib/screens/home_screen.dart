import 'package:flutter/material.dart';
import 'package:to_do_list/screens/calender_screen.dart';
import 'package:to_do_list/screens/tasks.dart';
import 'package:to_do_list/utils/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    Tasks(),
    CalendarScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(_currentIndex == 0 ? 'Tasks' : 'Calendar'),
      // ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedLabelStyle:
            TextStyle(color: AppColors.secondaryColor.withOpacity(.5)),
        fixedColor: AppColors.secondaryColor.withOpacity(.5),
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            backgroundColor: AppColors.secondaryColor.withOpacity(.5),
            icon: Icon(
              Icons.calendar_today,
              // color: AppColors.secondaryColor.withOpacity(.5),
            ),
            label: 'Calendar',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
