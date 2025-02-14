import 'dart:async';
import 'dart:math';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:dice_roll/widgets/dice.dart';
import 'package:dice_roll/widgets/dice_rolling.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(DiceApp());
}

class DiceApp extends StatefulWidget {
  const DiceApp({super.key});

  @override
  State<DiceApp> createState() => _DiceAppState();
}

class _DiceAppState extends State<DiceApp> {
  int _currentDice = 0;
  bool _rolling = false;

  void _roll() {
    setState(() {
      // roll state to true
      _rolling = true;

      // play sound
      AssetsAudioPlayer.newPlayer()
          .open(Audio("assets/sounds/dice_roll.mp3"), autoStart: true);

      // initialize in advance what would be the next face
      _currentDice = Random().nextInt(5);

      // countdown to 5
      Timer(const Duration(seconds: 3), () {
        setState(() {
          // set rolling to false
          _rolling = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(20.00),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _rolling == true
                      ? DiceRolling()
                      : Padding(
                          padding: const EdgeInsets.all(50),
                          child: Dice(no: _currentDice)),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ElevatedButton(
                      onPressed: _roll,
                      child: Text('Roll'),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
