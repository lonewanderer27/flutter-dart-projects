import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoriteMealsNotifier extends StateNotifier<List<String>> {
  FavoriteMealsNotifier() : super([]);

  bool toggleMealFavoriteStatus(String id) {
    final isExisting = state.contains(id);

    if (isExisting) {
      // if the ID exists, we create a new list without it
      state = state.where((id) => id != id).toList();
      return false;
    } else {
      // otherwise we create a new list with the new ID
      // note that we put the new fav ID first to put the new favorite item
      // at the top of the state
      state = [id, ...state];
      return true;
    }
  }
}

final favoriteMealsProvider =
    StateNotifierProvider<FavoriteMealsNotifier, List<String>>((ref) {
  return FavoriteMealsNotifier();
});
