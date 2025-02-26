import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapdown/models/favorite_place.dart';

class FavoritePlacesNotifier extends StateNotifier<List<FavoritePlace>> {
  FavoritePlacesNotifier() : super([]);
}

final favoritePlacesProvider =
    StateNotifierProvider<FavoritePlacesNotifier, List<FavoritePlace>>((ref) {
  return FavoritePlacesNotifier();
});
