import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:quiz_app/data/questions.dart';
import 'package:quiz_app/models/answer.dart';
import 'package:quiz_app/models/question.dart';
import 'package:quiz_app/screens/questions.dart';
import 'package:quiz_app/screens/result.dart';
import 'package:quiz_app/screens/start.dart';

class Quiz extends StatefulWidget {
  const Quiz({super.key});

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  late List<Question> _questions;
  late List<Answer> _answers;
  late Widget _activeScreen;

  void _chooseAnswer(String answer, Question question, int no) {
    debugPrint('Received answer: $answer');

    setState(() {
      if (_answers.elementAtOrNull(no) != null) {
        // there's already a previous answer in this index
        _answers[no] = Answer(question: question, userAnswer: answer);
      } else {
        // otherwise we're adding a new answer
        _answers.insert(
          no,
          Answer(question: question, userAnswer: answer),
        );
      }
    });
    inspect(_answers);
  }

  void _startQuiz() {
    setState(() {
      // make a new copy of the questions
      List<Question> newQuestions = questions;

      // shuffle the questions
      newQuestions.shuffle();

      // assign it to our local var of questions
      _questions = newQuestions;

      // grow our answers list based on the length of the questions
      // _answers = List.filled(_questions.length,
      //     _ => Answer(question: questions[0], userAnswer: '', no: index),
      //     growable: true);
      _answers = List.generate(_questions.length,
          (_) => Answer(question: questions[0], userAnswer: ''));

      // instantiate our new questions screen
      _activeScreen = Questions(
          questions: _questions,
          answers: _answers,
          chooseAnswer: _chooseAnswer);
    });
  }

  void _finishQuiz() {
    setState(() {
      _activeScreen = const ResultScreen();
    });
  }

  @override
  void initState() {
    super.initState();
    _activeScreen = StartScreen(_startQuiz);
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
