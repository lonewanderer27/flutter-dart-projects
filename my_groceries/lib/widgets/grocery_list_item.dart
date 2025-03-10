import 'package:flutter/material.dart';
import 'package:my_groceries/models/grocery_item.dart';
import 'package:my_groceries/screens/update_item_screen.dart';
import 'package:skeletonizer/skeletonizer.dart';

class GroceryListItem extends StatelessWidget {
  const GroceryListItem(
      {super.key,
      required this.item,
      required this.handleDelete,
      required this.index});
  final GroceryItem item;
  final int index;
  final void Function(String id, int index) handleDelete;

  @override
  Widget build(BuildContext context) {
    void handleTap() {
      // show the update screen
      Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => UpdateItemScreen(
                groceryItem: item,
                index: index,
              )));
    }

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
        // ref.read(groceryItemsProvider.notifier).deleteItem(item.id, context);
        handleDelete(item.id, index);
      },
      child: InkWell(
        onTap: handleTap,
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
              height: 18,
              width: 18,
              child: Text(
                item.quantity.toString(),
                style: TextStyle(fontSize: 15),
              )),
        ),
      ),
    );
  }
}
