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
  late List<Answer?> _answers;
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
      _answers = List.generate(_questions.length, (_) => null);

      // instantiate our new questions screen
      _activeScreen = Questions(
          questions: _questions,
          answers: _answers,
          chooseAnswer: _chooseAnswer,
          finishQuiz: _finishQuiz);
    });
  }

  bool _unansweredQuestions() {
    return _answers.any((q) => q == null);
  }

  void _finishQuiz() {
    // check if there are still null values in answers list
    if (_unansweredQuestions() == true) {
      // if there is, warn the user
      _incompleteAnswersDialog(context);
      return;
    }

    // all answers are complete, proceed with submission
    _submitQuiz();
  }

  void _submitQuiz() {
    setState(() {
      _activeScreen = ResultScreen(
          questions: _questions,
          answers: _answers.toList(),
          restartQuiz: _restartQuiz);
    });
  }

  void _restartQuiz() {
    setState(() {
      // empty the answers array
      _answers = [];

      // set the active screen to the start screen
      _activeScreen = StartScreen(_startQuiz);
    });
  }

  @override
  void initState() {
    super.initState();
    _activeScreen = StartScreen(_startQuiz);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [Colors.deepPurple, Color.fromARGB(255, 107, 15, 168)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        child: _activeScreen,
      ),
    );
  }

  Future<void> _incompleteAnswersDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Incomplete Answers'),
            content: const Text(
                'Some questions are still unanswered. Take a moment to complete them!'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Review Answers')),
              TextButton(onPressed: _submitQuiz, child: Text('Submit Anyway'))
            ],
          );
        });
  }
}
