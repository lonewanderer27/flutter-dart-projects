import 'package:flutter/material.dart';
import 'package:second_flutter_app/gradient_text.dart';

void main() {
  // using const allows the widgets by the app
  // to be cached, improving performance.
  runApp(MyApp());
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
