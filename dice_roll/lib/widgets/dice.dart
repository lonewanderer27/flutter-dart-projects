import 'package:dice_roll/constants/assets.dart';
import 'package:flutter/material.dart';

class Dice extends StatelessWidget {
  const Dice({super.key, required this.no});

  final int no;
  String get faceAsset {
    switch (no) {
      case 0:
        return Assets.dice1;
      case 1:
        return Assets.dice2;
      case 2:
        return Assets.dice3;
      case 3:
        return Assets.dice4;
      case 4:
        return Assets.dice5;
      case 5:
        return Assets.dice6;
      default:
        return Assets.dice1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Image.asset(faceAsset, width: 200, height: 200);
  }
}
