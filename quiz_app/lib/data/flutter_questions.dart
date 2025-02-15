import 'package:quiz_app/models/fill_in_the_blank_question.dart';
import 'package:quiz_app/models/multiple_choice_question.dart';
import 'package:quiz_app/models/ordering_question.dart';
import 'package:quiz_app/models/true_false_question.dart';

var multipleChoiceQuestions = [
  MultipleChoiceQuestion(
    questionText: "Which function is used to start a Flutter application?",
    answers: ["run()", "main()", "runApp()", "start()"],
    correctAnswer: "runApp()",
  ),
  MultipleChoiceQuestion(
    questionText: "Which widget is the root of a Flutter app?",
    answers: ["StatelessWidget", "StatefulWidget", "MaterialApp", "Container"],
    correctAnswer: "MaterialApp",
  ),
  MultipleChoiceQuestion(
    questionText: "Which widget helps in managing the state in Flutter?",
    answers: ["Container", "StatefulWidget", "StatelessWidget", "Text"],
    correctAnswer: "StatefulWidget",
  ),
  MultipleChoiceQuestion(
    questionText: "Which command is used to create a new Flutter project?",
    answers: [
      "flutter create <project_name>",
      "flutter new <project_name>",
      "flutter start <project_name>",
      "flutter init <project_name>"
    ],
    correctAnswer: "flutter create <project_name>",
  ),
  MultipleChoiceQuestion(
    questionText: "Which widget is used to create a scrollable list in Flutter?",
    answers: ["ListView", "Column", "Row", "Stack"],
    correctAnswer: "ListView",
  )
];

var trueFalseQuestions = [
  TrueFalseQuestion(
    questionText: "Flutter is primarily used for web development.",
    correctAnswer: false,
  ),
  TrueFalseQuestion(
    questionText: "Flutter apps are written in Dart.",
    correctAnswer: true,
  ),
  TrueFalseQuestion(
    questionText: "A StatefulWidget cannot have a state change.",
    correctAnswer: false,
  ),
  TrueFalseQuestion(
    questionText: "Flutter uses a declarative UI approach.",
    correctAnswer: true,
  ),
  TrueFalseQuestion(
    questionText: "setState() is used to update the UI in a StatefulWidget.",
    correctAnswer: true,
  ),
];

var fillInTheBlanksQuestions = [
  FillInTheBlankQuestion(
    questionText: "The primary programming language used in Flutter is ____.",
    correctAnswer: "Dart",
  ),
  FillInTheBlankQuestion(
    questionText: "To create a new Flutter widget, we extend the ____ class.",
    correctAnswer: "StatelessWidget",
  ),
  FillInTheBlankQuestion(
    questionText:
        "To update the UI of a StatefulWidget, we use the method ____.",
    correctAnswer: "setState",
  ),
  FillInTheBlankQuestion(
    questionText:
        "To create a navigation route in Flutter, we use the ____ widget.",
    correctAnswer: "Navigator",
  ),
  FillInTheBlankQuestion(
    questionText:
        "The widget that serves as the root of a Material Design app is ____.",
    correctAnswer: "MaterialApp",
  )
];

var orderingQuestions = [
  OrderingQuestion(
    questionText: "Arrange the steps to create a Flutter project.",
    correctAnswer: [
      "Install Flutter SDK",
      "Create a new Flutter project",
      "Write UI code",
      "Run the app"
    ],
  ),
  OrderingQuestion(
    questionText: "Arrange the Flutter widget tree structure from top to bottom.",
    correctAnswer: ["MaterialApp", "Scaffold", "Column", "Text"],
  ),
  OrderingQuestion(
    questionText:
        "Arrange the steps to implement state management in a StatefulWidget.",
    correctAnswer: ["Create StatefulWidget", "Define State", "Call setState()"],
  ),
  OrderingQuestion(
    questionText: "Arrange the steps to navigate between screens in Flutter.",
    correctAnswer: [
      "Create two screens",
      "Use Navigator.push()",
      "Use Navigator.pop() to go back"
    ],
  ),
  OrderingQuestion(
    questionText: "Arrange the Flutter widget lifecycle methods in order.",
    correctAnswer: [
      "createState()",
      "initState()",
      "build()",
      "setState()",
      "dispose()"
    ],
  )
];

var flutterQuestions = [
  ...multipleChoiceQuestions,
  ...trueFalseQuestions,
  ...fillInTheBlanksQuestions,
  ...orderingQuestions
];
