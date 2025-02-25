import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_groceries/providers/grocery_items_provider.dart';
import 'package:my_groceries/screens/new_item_screen.dart';
import 'package:my_groceries/widgets/grocery_list.dart';

class GroceryListScreen extends ConsumerStatefulWidget {
  const GroceryListScreen({super.key, required this.title});
  final String title;
  @override
  ConsumerState<GroceryListScreen> createState() => _GroceryListState();
}

class _GroceryListState extends ConsumerState<GroceryListScreen> {
  // In statefull widget, we can automatically access the context
  // so it does not matter even if we do it outside of the build method.
  void addGrocery() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => NewItemScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final groceryItems = ref.watch(groceryItemsProvider);
    Widget content = GroceryList(groceryItems);

    if (groceryItems.data.isEmpty &&
        groceryItems.isLoading == false &&
        groceryItems.error == null) {
      content = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'No grocery items found. Start adding some!',
            style: TextStyle(fontSize: 17),
          )
        ],
      );
    }

    if (groceryItems.data.isEmpty &&
        groceryItems.isLoading == false &&
        groceryItems.error != null) {
      content = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            groceryItems.error!,
            style: TextStyle(color: Colors.red, fontSize: 17),
          )
        ],
      );
    }

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
          child: content),
      floatingActionButton: FloatingActionButton(
        onPressed: addGrocery,
        tooltip: 'Add Grocery',
        child: const Icon(Icons.add),
      ),
    );
  }
}
