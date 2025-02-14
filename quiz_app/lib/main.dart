import 'package:flutter/material.dart';
import 'package:quiz_app/widgets/start_screen.dart';

void main() {
  runApp(QuizApp());
}

class QuizApp extends StatefulWidget {
  const QuizApp({super.key});

  @override
  State<QuizApp> createState() => _QuizAppState();
}

class _QuizAppState extends State<QuizApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [
            Colors.deepPurple,
            Color.fromARGB(255, 107, 15, 168)
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: StartScreen(),
        ),
      ),
    );
  }
}
