import 'dart:convert';
import 'dart:developer';
import 'dart:math';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_groceries/data/categories.dart';
import 'package:my_groceries/models/category.dart';
import 'package:http/http.dart' as http;
import '../models/grocery_item.dart';

class GroceryItemsNotifier extends StateNotifier<List<GroceryItem>> {
  GroceryItemsNotifier() : super([]) {
    _fetchItems();
  }

  Future<void> _fetchItems() async {
    final res = await http.get(
        Uri.parse('https://${dotenv.env['BACKEND_URL']}/shopping-list.json'));

    if (res.statusCode == 200) {
      // decode the response body as a map which has a dynamic type for the value
      final data = jsonDecode(res.body) as Map<String, dynamic>;

      // temporary list that we'll place our grocery items to
      // before using this to replace our actual state
      final List<GroceryItem> groceryItems = [];

      // loop for each item inside the raw response body
      data.forEach((id, itemRawData) {
        // find the actual category object based on its title
        Category category = categories.entries
            .firstWhere(
                (category) => category.value.title == itemRawData['category'])
            .value;

        // create a new grocery item for each raw item
        var groceryItem = GroceryItem(
            id: id,
            name: itemRawData['name'],
            quantity: itemRawData['quantity'],
            category: category);

        // add the grocery item to the raw list
        groceryItems.add(groceryItem);
      });

      // replace our state with the new grocery items
      state = groceryItems;
    } else {
      // TODO: Handle data errors here.
    }
  }

  void addItem(String id, String name, int quantity, Category category) {
    var newItem =
        GroceryItem(id: id, name: name, quantity: quantity, category: category);

    state = [...state, newItem];

    // appending .json at the end tells JSON that we'll be sending an HTTP request ourselves to Firebase
    http.post(Uri.https(dotenv.env['BACKEND_URL']!, 'shopping-list.json'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': newItem.name,
          'quantity': newItem.quantity,
          'category': newItem.category.title
        }));
  }
}

final groceryItemsProvider =
    StateNotifierProvider<GroceryItemsNotifier, List<GroceryItem>>((ref) {
  return GroceryItemsNotifier();
});
