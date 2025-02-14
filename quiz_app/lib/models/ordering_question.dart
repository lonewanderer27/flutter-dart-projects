import 'package:flutter/foundation.dart';
import 'package:quiz_app/models/question.dart';

class OrderingQuestion extends Question {
  final List<String> correctOrder;

  OrderingQuestion({required String questionText, required this.correctOrder})
      : super(questionText);

  @override
  bool checkAnswer(dynamic answer) {
    if (answer is List<String>) {
      return listEquals(correctOrder, answer);
    }

    return false;
  }
}
