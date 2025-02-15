import 'package:flutter/material.dart';
import 'package:quiz_app/screens/questions.dart';
import 'package:quiz_app/screens/start.dart';

class Quiz extends StatefulWidget {
  const Quiz({super.key});

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  late Widget _activeScreen;

  void _startQuiz() {
    setState(() {
      _activeScreen = const Questions();
    });
  }

  @override
  void initState() {
    _activeScreen = StartScreen(_startQuiz);
    super.initState();
  }

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
          child: _activeScreen,
        ),
      ),
    );
  }
}
