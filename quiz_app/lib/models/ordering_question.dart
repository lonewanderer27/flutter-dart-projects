import 'package:flutter/foundation.dart';
import 'package:quiz_app/models/question.dart';

class OrderingQuestion extends Question {
  final List<String> correctAnswer;

  List<String> get shuffledAnswers {
    var shuffledAnswers = correctAnswer;
    // shuffle our answers
    shuffledAnswers.shuffle();
    return shuffledAnswers;
  }

  OrderingQuestion({required String questionText, required this.correctAnswer})
      : super(questionText);

  @override
  bool checkAnswer(dynamic answer) {
    if (answer is List<String>) {
      return listEquals(correctAnswer, answer);
    }

    return false;
  }
}
