import 'package:quiz_app/models/fill_in_the_blank_question.dart';
import 'package:quiz_app/models/multiple_choice_question.dart';
import 'package:quiz_app/models/ordering_question.dart';
import 'package:quiz_app/models/true_false_question.dart';

var multipleChoiceQuestions = [
  MultipleChoiceQuestion(
    questionText:
        "Which keyword is used to define a constant variable in Dart?",
    answers: ["const", "final", "static", "immutable"],
    correctAnswer: "const",
  ),
  MultipleChoiceQuestion(
    questionText: "What is the entry point of a Dart program?",
    answers: ["main()", "runApp()", "void()", "start()"],
    correctAnswer: "main()",
  ),
  MultipleChoiceQuestion(
    questionText: "Which data type represents null safety in Dart?",
    answers: ["null", "void", "?", "None of the above"],
    correctAnswer: "?",
  ),
  MultipleChoiceQuestion(
    questionText:
        "Which function is used to asynchronously delay execution in Dart?",
    answers: [
      "Future.delayed()",
      "await sleep()",
      "setTimeout()",
      "Thread.sleep()"
    ],
    correctAnswer: "Future.delayed()",
  ),
  MultipleChoiceQuestion(
    questionText: "Which collection type maintains key-value pairs in Dart?",
    answers: ["List", "Set", "Map", "Array"],
    correctAnswer: "Map",
  )
];

var trueFalseQuestions = [
  TrueFalseQuestion(
    questionText: "Dart is a statically-typed language.",
    correctAnswer: true,
  ),
  TrueFalseQuestion(
    questionText: "Dart supports operator overloading.",
    correctAnswer: true,
  ),
  TrueFalseQuestion(
    questionText: "Dart does not support multiple inheritance.",
    correctAnswer: true,
  ),
  TrueFalseQuestion(
    questionText:
        "The default value of an uninitialized variable in Dart is 0.",
    correctAnswer: false,
  ),
  TrueFalseQuestion(
    questionText: "Dart uses a garbage collector for memory management.",
    correctAnswer: true,
  ),
];

var fillInTheBlanksQuestions = [
  FillInTheBlankQuestion(
    questionText: "The keyword used to declare a function in Dart is ____.",
    correctAnswer: "void",
  ),
  FillInTheBlankQuestion(
    questionText:
        "To create an immutable variable, we use either 'const' or ____.",
    correctAnswer: "final",
  ),
  FillInTheBlankQuestion(
    questionText: "Dart programs are compiled into ____ before execution.",
    correctAnswer: "machine code",
  ),
  FillInTheBlankQuestion(
    questionText: "The default access modifier in Dart is ____.",
    correctAnswer: "public",
  ),
  FillInTheBlankQuestion(
    questionText: "The main function in Dart has a return type of ____.",
    correctAnswer: "void",
  )
];

var orderingQuestions = [
  OrderingQuestion(
    questionText:
        "Arrange the data types in Dart from smallest to largest memory size.",
    correctAnswer: ["bool", "int", "double", "String"],
  ),
  OrderingQuestion(
    questionText: "Arrange the steps for using Futures in Dart.",
    correctAnswer: [
      "Define Future",
      "Use then() or await",
      "Handle errors",
      "Process result"
    ],
  ),
  OrderingQuestion(
    questionText: "Arrange the lifecycle of a Dart program execution.",
    correctAnswer: ["Compile", "Run", "Garbage Collection", "Exit"],
  ),
  OrderingQuestion(
    questionText:
        "Arrange the keywords in Dart from least to most restrictive.",
    correctAnswer: ["public", "protected", "private"],
  ),
  OrderingQuestion(
    questionText: "Arrange the steps to define a class in Dart.",
    correctAnswer: [
      "Define class",
      "Add constructor",
      "Define methods",
      "Create object"
    ],
  )
];

var dartQuestions = [
  ...multipleChoiceQuestions,
  ...trueFalseQuestions,
  ...fillInTheBlanksQuestions,
  // ...orderingQuestions
];
