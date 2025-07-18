import 'package:book_grocer/view/login/sign_in_view.dart';
import 'package:book_grocer/view/login/sign_up_view.dart';
import 'package:flutter/material.dart';

import '../common_widget/round_button.dart';

void showSignInRequiredDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        'Sign In Required',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'You need an account to view or rent books. Sign in or create a free account to continue.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          RoundLineButton(
            title: 'Sign In',
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SignInView()),
              );
            },
          ),
          const SizedBox(height: 10),
          RoundButton(
            title: 'Sign Up',
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SignUpView()),
              );
            },
          ),
        ],
      ),
    ),
  );
}
