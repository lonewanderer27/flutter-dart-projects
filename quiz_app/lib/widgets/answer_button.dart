import 'package:flutter/material.dart';

class AnswerButton extends StatelessWidget {
  const AnswerButton(
      {super.key,
      required this.label,
      required this.onPressed,
      this.selected = false});

  final String label;
  final void Function() onPressed;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor: selected ? Color(0xFF170050) : null,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
          maximumSize: Size.infinite,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
      child: Text(label),
    );
  }
}
