import 'package:dashboard/screens/login_page.dart';
import 'package:flutter/material.dart';

// import 'package:my_app/src/screens/loginPage.dart';
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    // Simulate a 1-second delay using Future.delayed
    Future.delayed(const Duration(seconds: 5), () {
      // Navigate to the Home Page
      Navigator.push(
        // ignore: use_build_context_synchronously
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          pageBuilder: (_, __, ___) => const LoginScreen(),
        ),
      );
    });

    // You can add any loading animation or branding elements to your splash screen
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SizedBox(
            width: screenWidth * 08,
            child: Image.asset('assets/images/doh-logo.png'),
          ),
        ),
      ),
    );
  }
}
