import 'package:flutter/material.dart';
import 'package:quiz_app/constants/assets.dart';

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
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(Assets.quizLogo, width: 250),
                  Padding(
                    padding: EdgeInsets.only(top: 50, bottom: 30),
                    child: Text('Learn Flutter the fun way!',
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                  ),
                  ElevatedButton(
                      onPressed: null,
                      child: Text(
                        'Start Quiz',
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
