import 'package:flutter/material.dart';
import 'package:to_do_list/screens/welcome_screen.dart'; // Adjust path if needed
import 'package:to_do_list/utils/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          height: 320,
          width: 320,
          child: Image.asset(
            'assets/appLogo.jpeg', // Replace with your actual logo path
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
