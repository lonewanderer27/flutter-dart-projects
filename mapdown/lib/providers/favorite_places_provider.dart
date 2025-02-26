import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapdown/data/dummy_places.dart';
import 'package:mapdown/models/favorite_place.dart';

class FavoritePlacesNotifier extends StateNotifier<List<FavoritePlace>> {
  FavoritePlacesNotifier() : super([...dummyPlaces]);

  void add(String name, File image) {
    state = [...state, FavoritePlace(name: name, image: image)];
  }
}

final favoritePlacesProvider =
    StateNotifierProvider<FavoritePlacesNotifier, List<FavoritePlace>>((ref) {
  return FavoritePlacesNotifier();
});
