import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
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
        if (res.body == 'null') {
          state = state.copyWith(isLoading: false);

          return;
        }

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

      inspect(error);

      state = state.copyWith(
          error: 'Failed to fetch data. Please try again later.');
    }

    // set loading to false
    state = state.copyWith(isLoading: false);
  }

  // to change
  Future<bool> replaceItem(String id, String name, int quantity,
      Category category, int index) async {
    // deleting an item should be instantaneous in the UI
    // therefore, we should keep the grocery item temporarily
    // do the http put request, if that fails
    // lets warn the user that it was unsuccessful then
    // we can revert the item back.

    // save the previous version of our item
    GroceryItem prevItem = state.data.firstWhere((item) => item.id == id);

    // create the next version of our item
    GroceryItem nextItem =
        GroceryItem(id: id, name: name, quantity: quantity, category: category);

    // set loading to true
    // and since our state is immutable
    // we create a new data list with the updated data
    var prevData = state.data;
    prevData[index] = nextItem;
    state = state.copyWith(data: prevData, isLoading: true);

    // do the http request
    try {
      final res = await http.put(
          Uri.https(dotenv.env['BACKEND_URL']!, 'shopping-list/$id.json'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'name': name,
            'quantity': quantity,
            'category': category.title
          }));

      if (res.statusCode != 200) {
        // our request have failed, therefore we need to put the item back
        // set the error response to a generic message
        // and set loading to false
        state = state.copyWith(
            data: [...state.data, prevItem],
            isLoading: false,
            error: "Failed to update item. Please try again later.");

        // return a false since we had an error
        return false;
      }

      // otherwise our operation has been successful
      state = state.copyWith(
        isLoading: false,
      );

      // then return true so we can dismiss the update screen
      return true;
    } catch (error) {
      inspect(error);

      // our request have failed, therefore we need to put the item back
      // set the error response to a generic message
      // and set loading to false
      state = state.copyWith(
          data: [...state.data, prevItem],
          isLoading: false,
          error: "Failed to update item. Please try again later.");

      // return a false since we had an error
      return false;
    }
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
      inspect(error);

      // TODO: Get the real firebase error then set that as the error message,
      // instead we just assign a generic error message;

      state = state.copyWith(
          error: 'Failed to fetch data. Please try again later.');
    }

    state = state.copyWith(isLoading: false);
  }

  Future<void> deleteItem(String id, BuildContext ctx) async {
    // deleting an item should be instantaneous
    // therefore, we should keep the grocery item temporarily
    // do the http delete request, if that fails
    // lets warn the user that it was unsuccessful then
    // we can move the item back.

    // save the item to be deleted
    var deletedItem = state.data.firstWhere((item) => item.id == id);

    // create a new state without the now delete grocery item
    // since the state is immutable
    state = state.copyWith(
        data: state.data.where((item) => item.id != id).toList());

    // send delete request to backend
    try {
      final res = await http
          .delete(Uri.https(dotenv.env['BACKEND_URL']!, 'shopping-list.json'));

      if (res.statusCode == 200) {
        // notice the user that we're succesful
        // give them the option to restore the item

        // ignore: use_build_context_synchronously
        // ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        //   duration: const Duration(seconds: 3),
        //   content: const Text('Grocery item deleted'),
        //   action: SnackBarAction(label: 'Undo', onPressed: () {
        //     //
        //   }),
        // ));

        // I realized giving them an option to restore that deleted
        // item opens a whole can of worms. So we will not do anything for now.
      } else {
        // we're not successful, so we move back the grocery item to state
        state = state.copyWith(data: [...state.data, deletedItem]);

        // warn the user that the deletion has been unsuccessful
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
            duration: const Duration(seconds: 3),
            content: const Text('There has been error. Please try again.')));
      }
    } catch (error) {
      inspect(error);

      // we're not successful, so we move back the grocery item to state
      state = state.copyWith(data: [...state.data, deletedItem]);

      // warn the user that the deletion has been unsuccessful
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
          duration: const Duration(seconds: 3),
          content: const Text('There has been error. Please try again.')));
    }
    state = state.copyWith(isLoading: false);
  }
}

final groceryItemsProvider =
    StateNotifierProvider<GroceryItemsNotifier, GroceryItemsState>((ref) {
  return GroceryItemsNotifier();
});
