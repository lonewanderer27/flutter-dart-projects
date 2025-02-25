import 'package:flutter/material.dart';
import 'package:my_groceries/models/grocery_item.dart';
import 'package:skeletonizer/skeletonizer.dart';

class GroceryListItem extends StatelessWidget {
  const GroceryListItem({super.key, required this.item});
  final GroceryItem item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
    );
  }
}
