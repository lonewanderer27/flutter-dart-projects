import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_groceries/data/categories.dart';
import 'package:my_groceries/models/category.dart';
import 'package:http/http.dart' as http;
import '../models/grocery_item.dart';

class GroceryItemsState {
  final bool isLoading;
  final String? error;
  final List<GroceryItem> data;

  GroceryItemsState(
      {required this.isLoading, required this.data, required this.error});

  GroceryItemsState copyWith(
      {bool? isLoading, List<GroceryItem>? data, String? error}) {
    return GroceryItemsState(
        isLoading: isLoading ?? this.isLoading,
        data: data ?? this.data,
        error: error ?? this.error);
  }
}

class GroceryItemsNotifier extends StateNotifier<GroceryItemsState> {
  GroceryItemsNotifier()
      : super(GroceryItemsState(isLoading: true, data: [], error: null)) {
    _fetchItems();
  }

  Future<void> _fetchItems() async {
    state = state.copyWith(isLoading: true);

    try {
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
        state = state.copyWith(data: groceryItems);
      } else {
        // TODO: Get the real firebase error then set that as the error message,
        // instead we just assign a generic error message;

        state = state.copyWith(
            error: 'Failed to fetch data. Please try again later.');
      }
    } catch (error) {
      // TODO: Get the real firebase error then set that as the error message,
      // instead we just assign a generic error message;

      state = state.copyWith(
          error: 'Failed to fetch data. Please try again later.');
    }

    // set loading to false
    state = state.copyWith(isLoading: false);
  }

  Future<void> addItem(
      String id, String name, int quantity, Category category) async {
    state = state.copyWith(isLoading: true);

    try {
      // appending .json at the end tells JSON that we'll be sending an HTTP request ourselves to Firebase
      final res = await http.post(
          Uri.https(dotenv.env['BACKEND_URL']!, 'shopping-list.json'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'name': name,
            'quantity': quantity,
            'category': category.title
          }));

      if (res.statusCode == 200) {
        // decode the response body as a map
        // sending an http post request to firebase realtime db yields us with a response body
        // that contains a 'name' key that contains the ID of the newly created item
        final data = jsonDecode(res.body) as Map<String, dynamic>;

        // create a new grocery item with the ID of the newly generated item
        // so that the data is consistent between local (state) and the server (firebase)
        var newItem = GroceryItem(
            id: data['name'],
            name: name,
            quantity: quantity,
            category: category);

        // append the new grocery item
        state = state.copyWith(data: [...state.data, newItem]);
      } else {
        // TODO: Get the real firebase error then set that as the error message,
        // instead we just assign a generic error message;

        state = state.copyWith(
            error: 'Failed to fetch data. Please try again later.');
      }
    } catch (error) {
      // TODO: Get the real firebase error then set that as the error message,
      // instead we just assign a generic error message;

      state = state.copyWith(
          error: 'Failed to fetch data. Please try again later.');
    }

    state = state.copyWith(isLoading: false);
  }

  Future<void> deleteItem(String id) async {
    state = state.copyWith(isLoading: true);

    final res = await http
        .delete(Uri.https(dotenv.env['BACKEND_URL']!, 'shopping-list.json'));

    if (res.statusCode == 200) {
      // create a new state without the now delete grocery item
      // since the state is immutable
      state = state.copyWith(
          data: state.data.where((item) => item.id != id).toList());
    } else {
      // TODO: Get the real firebase error then set that as the error message,
      // instead we just assign a generic error message;
    }

    state = state.copyWith(isLoading: false);
  }
}

final groceryItemsProvider =
    StateNotifierProvider<GroceryItemsNotifier, GroceryItemsState>((ref) {
  return GroceryItemsNotifier();
});
