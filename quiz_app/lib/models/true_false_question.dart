import 'package:quiz_app/models/question.dart';

class TrueFalseQuestion extends Question {
  final bool correctAnswer;

  TrueFalseQuestion({required String questionText, required this.correctAnswer})
      : super(questionText);

  @override
  bool checkAnswer(dynamic answer) {
    if (answer is bool) {
      return answer == correctAnswer;
    }

    return false;
  }
}
