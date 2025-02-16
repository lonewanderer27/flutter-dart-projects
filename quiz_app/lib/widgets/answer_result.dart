import 'package:flutter/material.dart';
import 'package:quiz_app/models/answer.dart';
import 'package:quiz_app/models/fill_in_the_blank_question.dart';
import 'package:quiz_app/models/multiple_choice_question.dart';
import 'package:quiz_app/models/question.dart';
import 'package:quiz_app/models/true_false_question.dart';

class AnswerResult extends StatelessWidget {
  const AnswerResult(
      {super.key, required this.question, required this.no, this.answer});

  final Question question;
  final Answer? answer;
  final int no;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            borderRadius: BorderRadius.circular(30.0),
            color: (answer != null && answer!.isCorrect)
                ? Colors.green
                : Colors.blueGrey,
            child: MaterialButton(
                onPressed: () {},
                minWidth: 40,
                child: Text(
                  '$no',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.start,
                )),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question.questionText,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                // if the answer is null, then the user has skipped this question
                // so indicate it here
                answer == null
                    ? Text(
                        '✖️ N/A',
                        style: TextStyle(color: Colors.white),
                      )
                    // otherwise they either have a correct or wrong answer
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // show whether the user's answer was correct
                          Text(
                              '${answer!.isCorrect ? '✅' : '✖️'} ${answer?.userAnswer}',
                              style: TextStyle(color: Colors.white)),
                          if (question is MultipleChoiceQuestion &&
                              answer?.isCorrect == false)
                            Text(
                                'Correct Answer: ${(question as MultipleChoiceQuestion).correctAnswer}',
                                style: TextStyle(color: Colors.white)),
                          if (question is TrueFalseQuestion &&
                              answer?.isCorrect == false)
                            Text(
                                'Correct Answer: ${(question as TrueFalseQuestion).correctAnswer}',
                                style: TextStyle(color: Colors.white)),
                          if (question is FillInTheBlankQuestion &&
                              answer?.isCorrect == false)
                            Text(
                              'Correct Answer: ${(question as FillInTheBlankQuestion).correctAnswer}',
                              style: TextStyle(color: Colors.white),
                            )
                        ],
                      )
              ],
            ),
          )
        ],
      ),
    );
  }
}
