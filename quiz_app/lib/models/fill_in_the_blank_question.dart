import 'package:quiz_app/models/question.dart';

class FillInTheBlankQuestion extends Question {
  final String correctAnswer;

  FillInTheBlankQuestion(
      {required String questionText, required this.correctAnswer})
      : super(questionText);

  @override
  bool checkAnswer(dynamic answer) {
    if (answer is String) {
      return (answer == correctAnswer || answer.contains(correctAnswer));
    }

    return false;
  }
}
