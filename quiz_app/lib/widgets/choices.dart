import 'package:flutter/material.dart';
import 'package:quiz_app/models/answer.dart';
import 'package:quiz_app/models/fill_in_the_blank_question.dart';
import 'package:quiz_app/models/multiple_choice_question.dart';
import 'package:quiz_app/models/ordering_question.dart';
import 'package:quiz_app/models/question.dart';
import 'package:quiz_app/models/true_false_question.dart';
import 'package:quiz_app/widgets/answer_button.dart';

class Choices extends StatefulWidget {
  const Choices(
      {super.key,
      required this.question,
      required this.setAnswer,
      this.answer});

  final Question question;
  final Answer? answer;
  final void Function(String answer) setAnswer;

  @override
  State<Choices> createState() => _ChoicesState();
}

class _ChoicesState extends State<Choices> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.answer?.userAnswer;
  }

  @override
  void didUpdateWidget(covariant Choices oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.answer?.userAnswer != widget.answer?.userAnswer) {
      _controller.text = widget.answer?.userAnswer;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Answer: ${widget.answer?.userAnswer}");

    return Padding(
      padding: EdgeInsets.all(20),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.question is MultipleChoiceQuestion) ...[
              ...(widget.question as MultipleChoiceQuestion).answers.map((opt) {
                return Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: AnswerButton(
                        label: opt,
                        onPressed: () {
                          widget.setAnswer(opt);
                        },
                        selected: widget.answer?.userAnswer == opt));
              })
            ],
            if (widget.question is TrueFalseQuestion) ...[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: AnswerButton(
                  label: 'True',
                  onPressed: () {
                    widget.setAnswer(true.toString());
                  },
                  selected: widget.answer?.userAnswer == true.toString(),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: AnswerButton(
                  label: 'False',
                  onPressed: () {
                    widget.setAnswer(false.toString());
                  },
                  selected: widget.answer?.userAnswer == false.toString(),
                ),
              )
            ],
            if (widget.question is FillInTheBlankQuestion) ...[
              TextField(
                style: TextStyle(color: Colors.white),
                controller: _controller,
                onChanged: (value) {
                  setState(() {
                    widget.setAnswer(value);
                  });
                },
              )
            ],
            if (widget.question is OrderingQuestion) ...[
              Padding(
                padding: EdgeInsets.only(bottom: 30),
                child: Text(
                  (widget.question as OrderingQuestion)
                      .shuffledAnswers
                      .join(', '),
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
              ...(widget.question as OrderingQuestion)
                  .shuffledAnswers
                  .map((opt) {
                return TextField(
                  style: TextStyle(color: Colors.white),
                );
              }),
            ]
          ],
        ),
      ),
    );
  }
}
