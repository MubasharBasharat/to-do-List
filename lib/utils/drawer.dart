import 'package:flutter/material.dart';
import 'package:to_do_list/providers/selected_category.dart';
import 'package:to_do_list/providers/theme_provider.dart';
import 'package:to_do_list/utils/app_colors.dart';
import 'package:to_do_list/model/tasks_model.dart';
import 'package:provider/provider.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({super.key});

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  bool _isCategoryExpanded = false;

  @override
  Widget build(BuildContext context) {
    final selectedCategory =
        context.watch<SelectedCategoryProvider>().selectedCategory;

    final themeProvider = context.watch<ThemeProvider>();
    final isDarkMode = themeProvider.isDarkMode;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppColors.secondaryColor,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/appLogo.jpeg", height: 100),
                  // const SizedBox(height: 12),
                  const Text(
                    'To-Do List',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
          ),

          // 📂 Category selector
          ExpansionTile(
            title: const Text("Category"),
            initiallyExpanded: _isCategoryExpanded,
            onExpansionChanged: (expanded) {
              setState(() => _isCategoryExpanded = expanded);
            },
            children: TaskCategory.values.map((category) {
              return ListTile(
                title: Text(category.name),
                onTap: () {
                  context
                      .read<SelectedCategoryProvider>()
                      .selectCategory(category);
                  setState(() => _isCategoryExpanded = false);
                  Navigator.pop(context); // close drawer
                },
              );
            }).toList(),
          ),
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return ListTile(
                leading: const Icon(Icons.brightness_6),
                title: const Text("Dark Mode"),
                trailing: Switch(
                  value: themeProvider.isDarkMode,
                  onChanged: (val) => themeProvider.toggleTheme(val),
                  activeTrackColor: AppColors.secondaryColor,
                  inactiveTrackColor: Colors.black,
                  trackColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      return states.contains(MaterialState.selected)
                          ? AppColors.secondaryColor
                          : Colors.white;
                    },
                  ),
                  thumbColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      return Colors.black;
                    },
                  ),
                ),
              );
            },
          ),

          // 🌗 Theme toggle switch
          // SwitchListTile(
          //   title: const Text("Dark Mode"),
          //   secondary: const Icon(Icons.brightness_6),
          //   value: isDarkMode,
          //   onChanged: (val) => themeProvider.toggleTheme(val),
          // ),

          // 🔒 Privacy Policy
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text("Privacy Policy"),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Privacy Policy"),
                  content: const Text("Your privacy matters."),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Close"),
                    )
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
