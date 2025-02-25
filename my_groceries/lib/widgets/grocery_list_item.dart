import 'package:flutter/material.dart';
import 'package:my_groceries/models/grocery_item.dart';

class GroceryListItem extends StatelessWidget {
  const GroceryListItem({super.key, required this.item});
  final GroceryItem item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
        width: 25.0,
        height: 25.0,
        child: Container(
          decoration: BoxDecoration(
              color: item.category.color,
              borderRadius: BorderRadius.circular(5)),
        ),
      ),
      title: Text(item.name),
      trailing: Text(item.quantity.toString()),
    );
  }
}
