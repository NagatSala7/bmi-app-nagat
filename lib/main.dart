import 'package:flutter/material.dart';
import 'intro_page.dart';

void main() {
  runApp(const BmiApplication());
}

class BmiApplication extends StatelessWidget {
  const BmiApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BMI App',
      home: const IntroPage(),
    );
  }
}
