import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/utils/app_colors.dart';
import 'package:to_do_list/screens/home_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  late final List<Animation<Offset>> _animations;

  bool _showContinue = false;

  final List<Map<String, String>> _features = [
    {
      'title': 'Smart Task Management',
      'subtitle': 'Organize your life with intelligent task sorting.'
    },
    {
      'title': 'Timely Reminders',
      'subtitle': 'Get notified exactly when it matters most.'
    },
    {
      'title': 'Category Filters',
      'subtitle': 'Filter tasks by personal, work, wishlist, and more.'
    },
  ];

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(
      _features.length,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1000), // Longer animation
      ),
    );

    _animations = _controllers.map((controller) {
      return Tween<Offset>(
        begin: const Offset(1.5, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));
    }).toList();

    _startAnimations();
  }

  Future<void> _startAnimations() async {
    for (int i = 0; i < _controllers.length; i++) {
      await Future.delayed(const Duration(milliseconds: 600));
      _controllers[i].forward();
    }
    setState(() => _showContinue = true);
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = AppColors.secondaryColor.withOpacity(0.5);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background, // Auto theme background
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'Welcome to Smart Tasks!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Animated tiles
                ...List.generate(_features.length, (index) {
                  return SlideTransition(
                    position: _animations[index],
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 24),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: borderColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          _features[index]['title']!,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onBackground,
                          ),
                        ),
                        subtitle: Text(
                          _features[index]['subtitle']!,
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.onBackground.withOpacity(0.8),
                          ),
                        ),
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 24),

                if (_showContinue)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              AppColors.secondaryColor.withOpacity(0.5),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text("Continue"),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const HomeScreen()),
                          );
                        },
                      ),
                    ),
                  ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
