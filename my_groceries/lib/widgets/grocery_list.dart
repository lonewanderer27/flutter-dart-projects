import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_groceries/data/categories.dart';
import 'package:my_groceries/models/grocery_item.dart';
import 'package:my_groceries/providers/grocery_items_provider.dart';
import 'package:my_groceries/widgets/grocery_list_item.dart';
import 'package:skeletonizer/skeletonizer.dart';

class GroceryList extends ConsumerWidget {
  GroceryList(
    this.groceryItemsState, {
    super.key,
  });
  final GroceryItemsState groceryItemsState;
  final fakeGroceryItems = List.filled(10,
      GroceryItem(name: '', quantity: 99, category: categories.values.first));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void handleDelete(String id, int index) {
      ref.read(groceryItemsProvider.notifier).deleteItem(id, context, index);
    }

    if (groceryItemsState.isLoading) {
      return Skeletonizer(
        enabled: true,
        child: ListView.builder(
            itemCount: fakeGroceryItems.length,
            itemBuilder: (ctx, index) => GroceryListItem(
                  item: fakeGroceryItems[index],
                  handleDelete: handleDelete,
                  index: index,
                )),
      );
    }

    return ListView.builder(
        itemCount: groceryItemsState.data.length,
        itemBuilder: (ctx, index) => GroceryListItem(
            item: groceryItemsState.data[index],
            handleDelete: handleDelete,
            index: index));
  }
}
