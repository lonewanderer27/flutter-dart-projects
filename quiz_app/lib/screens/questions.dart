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

  void _updateQuestion() {
    setState(() {
      currentQuestion = questions.elementAt(currentNo);
      print('Current question: $currentQuestion');
    });
  }

  void _firstQuestion() {
    setState(() {
      currentNo = 0;
      _updateQuestion();
    });
  }

  void _lastQuestion() {
    setState(() {
      currentNo = questions.length - 1;
      _updateQuestion();
    });
  }

  void _nextQuestion() {
    if (currentNo == questions.length - 1) return;
    setState(() {
      currentNo++;
      _updateQuestion();
    });
  }

  void _prevQuestion() {
    if (currentNo == 0) return;
    setState(() {
      currentNo--;
      _updateQuestion();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text('Question ${currentNo + 1} out of ${questions.length}',
                    style: TextStyle(color: Colors.white))
              ],
            ),
            Column(
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
              ],
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                            onPressed: currentNo == 0 ? null : _firstQuestion,
                            icon: Icon(Icons.first_page),
                            style: IconButton.styleFrom(
                                foregroundColor: Colors.white)),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: ElevatedButton.icon(
                            onPressed: currentNo == 0 ? null : _prevQuestion,
                            label: Text('Prev'),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        ElevatedButton.icon(
                            onPressed: currentNo == questions.length - 1
                                ? null
                                : _nextQuestion,
                            label: Text('Next')),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: IconButton(
                            onPressed: currentNo == questions.length - 1
                                ? null
                                : _lastQuestion,
                            icon: Icon(Icons.last_page),
                            style: IconButton.styleFrom(
                                foregroundColor: Colors.white),
                          ),
                        )
                      ],
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
