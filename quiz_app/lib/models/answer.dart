import 'package:quiz_app/models/question.dart';

class Answer {
  final Question question;
  final dynamic userAnswer;

  const Answer(
      {required this.question, required this.userAnswer});

  bool get isCorrect => question.checkAnswer(userAnswer);
}
