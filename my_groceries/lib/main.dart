import 'package:flutter/material.dart';
import 'package:my_groceries/screens/grocery_list_screen.dart';

void main() {
  runApp(const MyGroceriesApp());
}

class MyGroceriesApp extends StatelessWidget {
  const MyGroceriesApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const GroceryList(title: 'My Groceries'),
    );
  }
}