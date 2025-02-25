import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_groceries/providers/grocery_items_provider.dart';
import 'package:my_groceries/screens/new_item_screen.dart';
import 'package:my_groceries/widgets/grocery_list_item.dart';

class GroceryList extends ConsumerStatefulWidget {
  const GroceryList({super.key, required this.title});
  final String title;
  @override
  ConsumerState<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends ConsumerState<GroceryList> {
  // In statefull widget, we can automatically access the context
  // so it does not matter even if we do it outside of the build method.
  void addGrocery() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => NewItemScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final groceryItems = ref.watch(groceryItemsProvider);

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
        onPressed: addGrocery,
        tooltip: 'Add Grocery',
        child: const Icon(Icons.add),
      ),
    );
  }
}
