import 'package:flutter/material.dart';
import 'joke_list_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigateToHomePage();
    });
  }

  Future<void> _navigateToHomePage() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return; // Ensure the widget is still mounted before navigating
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const JokeListPage(title: 'Jokes For You 😊'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[600],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Icon
            Image.asset(
              'assets/icon/app_icon.png', // Path to the app icon
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 20),
            // App Name
            Text(
              'Joke App',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 20),
            // Loading Indicator
            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
