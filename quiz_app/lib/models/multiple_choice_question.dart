import 'package:quiz_app/models/question.dart';

class MultipleChoiceQuestion extends Question {
  final List<String> answers;
  final String correctAnswer;

  List<String> get getShuffledAnswers {
    var shuffledAnswers = answers;
    // shuffle our answers
    shuffledAnswers.shuffle();
    return shuffledAnswers;
  }

  MultipleChoiceQuestion({
    required String questionText,
    required this.answers,
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
