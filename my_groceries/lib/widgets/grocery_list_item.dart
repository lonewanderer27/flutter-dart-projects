import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_groceries/models/grocery_item.dart';
import 'package:my_groceries/providers/grocery_items_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class GroceryListItem extends ConsumerWidget {
  const GroceryListItem({super.key, required this.item});
  final GroceryItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: Key(item.id),
      background: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.error,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Delete',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              Text(
                'Delete',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
      onDismissed: (direction) {
        ref.read(groceryItemsProvider.notifier).deleteItem(item.id);
      },
      child: ListTile(
        leading: Skeleton.replace(
            width: 25,
            height: 25,
            child: SizedBox(
              width: 25.0,
              height: 25.0,
              child: Container(
                decoration: BoxDecoration(
                    color: item.category.color,
                    borderRadius: BorderRadius.circular(5)),
              ),
            )),
        title: Skeleton.replace(
          height: 20,
          width: 50,
          child: Text(item.name),
        ),
        trailing: Skeleton.replace(
            height: 10, width: 10, child: Text(item.quantity.toString())),
      ),
    );
  }
}
