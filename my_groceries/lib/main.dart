import 'package:flutter/material.dart';
import 'package:my_groceries/data/dummy_items.dart';
import 'package:my_groceries/widgets/grocery_list_item.dart';

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
      home: const HomeScreen(title: 'My Groceries'),
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
        child: ListView(
          children: groceryItems
              .map((grocery) => GroceryListItem(item: grocery))
              .toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Add Grocery',
        child: const Icon(Icons.add),
      ),
    );
  }
}
