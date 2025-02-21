import 'package:flutter/material.dart';
import 'package:meals_coffee_lounge/data/meals.dart';
import 'package:meals_coffee_lounge/screens/categories_screen.dart';
import 'package:meals_coffee_lounge/screens/meals_screen.dart';
import 'package:meals_coffee_lounge/theme/theme.dart';

void main() {
  runApp(const MealsByCFLApp());
}

class MealsByCFLApp extends StatelessWidget {
  const MealsByCFLApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meals by CFL',
      theme: theme,
      home: CategoriesScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});
  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                style: TextStyle(color: Colors.white),
                'Hello World',
              )
            ],
          ),
        ));
  }
}
