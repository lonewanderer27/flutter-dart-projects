import 'package:flutter/material.dart';
import 'package:second_flutter_app/constants/app_gradients.dart';
import 'package:second_flutter_app/gradient_text.dart';

void main() {
  // using const allows the widgets by the app
  // to be cached, improving performance.
  runApp(MyApp());
}

final String title = 'stratpoint';
final String description = 'Fast forward to the future';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(color: Colors.black),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Wrap(
                  children: [
                    GradientText(title.substring(0, 5),
                        gradient: AppGradients.stratpointGradient,
                        style: TextStyle(
                            fontSize: 50, fontWeight: FontWeight.bold)),
                    Text(
                      title.substring(5, title.length),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                GradientText(
                  description,
                  gradient: AppGradients.stratpointGradient,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                )
              ],
            )),
          ),
        ),
      ),
    );
  }
}
