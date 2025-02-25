import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_groceries/models/category.dart';

import '../models/grocery_item.dart';

class GroceryItemsNotifier extends StateNotifier<List<GroceryItem>> {
  GroceryItemsNotifier() : super([]);

  void addItem(String id, String name, int quantity, Category category) {
    state = [
      ...state,
      GroceryItem(id: id, name: name, quantity: quantity, category: category)
    ];
  }
}

final groceryItemsProvider =
    StateNotifierProvider<GroceryItemsNotifier, List<GroceryItem>>((ref) {
  return GroceryItemsNotifier();
});
