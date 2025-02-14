import 'package:flutter/material.dart';
import 'package:quiz_app/widgets/start_screen.dart';

class Quiz extends StatefulWidget {
  const Quiz({super.key});

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
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
