import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_coffee_lounge/screens/tabs_screen.dart';
import 'package:meals_coffee_lounge/theme/theme.dart';

void main() {
  runApp(ProviderScope(child: const MealsByCFLApp()));
}

class MealsByCFLApp extends StatelessWidget {
  const MealsByCFLApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meals by CFL',
      theme: theme,
      home: const TabsScreen(),
    );
  }
}
