import 'package:flutter/material.dart';

void main() {
  // using const allows the widgets by the app
  // to be cached, improving performance.
  runApp(MyApp());
}

class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    super.key,
    required this.gradient,
    this.style,
  });

  final String text;
  final TextStyle? style;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (Rect bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(text, style: style),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(color: Colors.black),
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Wrap(
                children: [
                  GradientText('strat',
                      gradient: LinearGradient(colors: <Color>[
                        Color(0xFF00bbf8),
                        Color(0xFF007ad6)
                      ]),
                      style:
                          TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
                  Text(
                    'point',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Text(
                'Fast forward to the future',
                style: TextStyle(fontSize: 25, color: Colors.white),
              )
            ],
          )),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// // With Flutter, you create user interfaces by combining "widgets"
// // You'll learn all about them (and much more) throughout this course!
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // Every custom widget must have a build() method
//   // It tells Flutter, which widgets make up your custom widget
//   // Again: You'll learn all about that throughout the course!
//   @override
//   Widget build(BuildContext context) {
//     // Below, a bunch of built-in widgets are used (provided by Flutter)
//     // They will be explained in the next sections
//     // In this course, you will, of course, not just use them a lot but
//     // also learn about many other widgets!
//     return MaterialApp(
//       title: 'Flutter First App',
//       theme: ThemeData(useMaterial3: true),
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Welcome to Flutter'),
//         ),
//         body: Container(
//           width: double.infinity,
//           padding: const EdgeInsets.all(12),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: const [
//               Text(
//                 'Flutter - The Complete Guide',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               SizedBox(height: 16),
//               Text(
//                 'Learn Flutter step-by-step, from the ground up.',
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
