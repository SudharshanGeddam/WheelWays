import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:wheelways/Screens/login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 183, 154, 233),
      body: Column(
        children: [
          Center(
            child: Image.asset(
              'assets/images/HCL-logo.png',
              height: 200,
              width: 200,
            ),
          ),
          const SizedBox(height: 50),
          Lottie.asset('assets/lotties/Bycicle delivery fast.json'),
          const SizedBox(height: 20),
          const Text(
            "WHEELWAYS",
            style: TextStyle(letterSpacing: 35.0, fontSize: 16),
            softWrap: false,
            overflow: TextOverflow.fade,
          ),
          const SizedBox(height: 30),
          FilledButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            ),
            child: Text('Get Started'),
          ),
        ],
      ),
    );
  }
}
