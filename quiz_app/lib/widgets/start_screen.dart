import 'package:flutter/material.dart';
import 'package:quiz_app/constants/assets.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(Assets.quizLogo, width: 250),
            Padding(
              padding: EdgeInsets.only(top: 50, bottom: 30),
              child: Text('Learn Flutter the fun way!',
                  style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
            ElevatedButton(
                onPressed: null,
                child: Text(
                  'Start Quiz',
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
      ),
    );
  }
}