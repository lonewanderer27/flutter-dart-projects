import 'package:quiz_app/models/question.dart';

class MultipleChoiceQuestion extends Question {
  final List<String> options;
  final String correctAnswer;

  MultipleChoiceQuestion({
    required String questionText,
    required this.options,
    required this.correctAnswer,
  }) : super(questionText);

  @override
  bool checkAnswer(dynamic answer) {
    if (answer is String) {
      return answer == correctAnswer;
    }

    return false;
  }
}
