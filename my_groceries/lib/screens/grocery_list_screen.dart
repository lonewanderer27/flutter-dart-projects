import 'package:flutter/material.dart';
import 'package:my_groceries/data/dummy_items.dart';
import 'package:my_groceries/widgets/grocery_list_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key, required this.title});
  final String title;
  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
          // Previous code:
          // child: ListView(
          //   children: groceryItems
          //       .map((grocery) => GroceryListItem(item: grocery))
          //       .toList(),
          // )
          // It's generally fine to output the items insdie of children directly
          // However for performance related reasons, we should use itemBuilder instead.
          child: ListView.builder(
              itemCount: groceryItems.length,
              itemBuilder: (ctx, index) =>
                  GroceryListItem(item: groceryItems[index]))),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Add Grocery',
        child: const Icon(Icons.add),
      ),
    );
  }
}
