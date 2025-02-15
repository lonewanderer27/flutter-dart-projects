import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiz_app/models/fill_in_the_blank_question.dart';
import 'package:quiz_app/models/multiple_choice_question.dart';
import 'package:quiz_app/models/ordering_question.dart';
import 'package:quiz_app/models/question.dart';
import 'package:quiz_app/models/true_false_question.dart';
import 'package:quiz_app/widgets/answer_button.dart';

class Choices extends StatelessWidget {
  const Choices({super.key, required this.question, required this.setAnswer});

  final Question question;
  final void Function(String) setAnswer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (question is MultipleChoiceQuestion) ...[
              ...(question as MultipleChoiceQuestion)
                  .getShuffledAnswers
                  .map((opt) {
                return Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: AnswerButton(
                        label: opt,
                        onPressed: () {
                          setAnswer(opt);
                        }));
              })
            ],
            if (question is TrueFalseQuestion) ...[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: AnswerButton(
                    label: 'True',
                    onPressed: () {
                      setAnswer('true');
                    }),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: AnswerButton(
                    label: 'False',
                    onPressed: () {
                      setAnswer('false');
                    }),
              )
            ],
            if (question is FillInTheBlankQuestion) ...[
              TextField(
                style: TextStyle(color: Colors.white),
              )
            ],
            if (question is OrderingQuestion) ...[
              Padding(
                padding: EdgeInsets.only(bottom: 30),
                child: Text(
                  (question as OrderingQuestion).shuffledAnswers.join(', '),
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
              ...(question as OrderingQuestion).shuffledAnswers.map((opt) {
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
