import 'package:book_grocer/common/color_extenstion.dart';
import 'package:book_grocer/view/login/sign_in_view.dart';
import 'package:book_grocer/view/onboarding/welcome_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookShare',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: TColor.primary,
        fontFamily: 'SF Pro Text',
      ),
      // Changed to show landing page first
      home: const WelcomeView(),
      // Define routes for navigation
      routes: {
        '/signin': (context) => const SignInView(),
      },
    );
  }
}
