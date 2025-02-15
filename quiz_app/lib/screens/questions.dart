import 'package:flutter/material.dart';
import 'package:quiz_app/data/questions.dart';
import 'package:quiz_app/models/question.dart';
import 'package:quiz_app/widgets/choices.dart';

class Questions extends StatefulWidget {
  const Questions({super.key});

  @override
  State<Questions> createState() => _QuestionsState();
}

class _QuestionsState extends State<Questions> {
  int currentNo = 0;
  late Question currentQuestion;

  @override
  void initState() {
    super.initState();
    // shuffle questions
    questions.shuffle();

    currentQuestion = questions.elementAt(currentNo);
  }

  void _setAnswer(String answer) {
    print('Q: ${currentQuestion.questionText}\nUser: $answer');
  }

  void _nextQuestion() {
    if (currentNo == questions.length - 1) return;
    setState(() {
      currentNo++;
      currentQuestion = questions.elementAt(currentNo);
      print('Current question: $currentQuestion');
    });
  }

  void _prevQuestion() {
    if (currentNo == 0) return;
    setState(() {
      currentNo--;
      currentQuestion = questions.elementAt(currentNo);
      print('Current question: $currentQuestion');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              currentQuestion.questionText,
              style: TextStyle(color: Colors.white, fontSize: 25),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            Choices(question: currentQuestion, setAnswer: _setAnswer),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: currentNo == 0 ? null : _prevQuestion,
                  label: Text('Prev'),
                  style: ElevatedButton.styleFrom(maximumSize: Size.infinite),
                ),
                ElevatedButton.icon(
                  onPressed:
                      currentNo == questions.length - 1 ? null : _nextQuestion,
                  label: Text('Next'),
                  style: ElevatedButton.styleFrom(maximumSize: Size.infinite),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
