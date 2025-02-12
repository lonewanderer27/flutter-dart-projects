import 'package:flutter/material.dart';

class Company {
  Company(
      {required this.name,
      required this.description,
      required this.nameGradient,
      required this.descriptionGradient,
      this.splitNameGradient = false});
  final String name;
  final String description;
  final LinearGradient nameGradient;
  final LinearGradient descriptionGradient;
  final bool? splitNameGradient;
}
