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
            Image.asset(
              Assets.quizLogo,
              width: 250,
              color: const Color.fromARGB(175, 255, 255, 255),
            ),
            Padding(
              padding: EdgeInsets.only(top: 50, bottom: 30),
              child: Text('Learn Flutter the fun way!',
                  style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
            OutlinedButton.icon(
              onPressed: () {},
              style: OutlinedButton.styleFrom(foregroundColor: Colors.white),
              label: Text('Start Quiz'),
              icon: Icon(Icons.arrow_right_alt_outlined, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
