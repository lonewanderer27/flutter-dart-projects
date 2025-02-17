import 'package:flutter/material.dart';
import 'package:quiz_app/models/answer.dart';
import 'package:quiz_app/models/question.dart';
import 'package:quiz_app/widgets/answer_result.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen(
      {super.key,
      required this.answers,
      required this.restartQuiz,
      required this.questions});
  final List<Question> questions;
  final List<Answer?> answers;
  final void Function() restartQuiz;

  List<Answer?> _getCorrectAnswers() {
    return answers
        .where((element) => element != null && element.isCorrect)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  'You answered ${_getCorrectAnswers().length} out of ${questions.length} questions correctly',
                  style: TextStyle(fontSize: 15, color: Colors.white)),
              SizedBox(height: 30),
              SizedBox(
                height: 550,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ...answers
                          .asMap()
                          .entries
                          .where((entry) => entry.key < questions.length)
                          .map((entry) {
                        var index = entry.key;
                        var value = entry.value;
                        return AnswerResult(
                            question: questions[index],
                            no: index + 1,
                            answer: value);
                      })
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton.icon(
                  icon: Icon(Icons.replay),
                  onPressed: restartQuiz,
                  label: Text('Restart Quiz!'))
            ],
          ),
        ));
  }
}
