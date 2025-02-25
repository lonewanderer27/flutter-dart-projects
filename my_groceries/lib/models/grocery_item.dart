import 'package:my_groceries/models/category.dart';
import 'package:uuid/uuid.dart';

final Uuid uuid = Uuid();

class GroceryItem {
  GroceryItem(
      {required this.name,
      required this.quantity,
      required this.category,
      // allows us to have a default value of ID if it's not provided for now
      String? id})
      : id = id ?? uuid.v4();

  final String id;
  final String name;
  final int quantity;
  final Category category;
}
