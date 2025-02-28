import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moments/models/place.dart';

class PlacesNotifier extends StateNotifier<List<Place>> {
  PlacesNotifier() : super([]);

  void add(String name, File image, DateTime dateTime) {
    state = [...state, Place(title: name, image: image, dateTime: dateTime)];
  }
}

final placesProvider =
    StateNotifierProvider<PlacesNotifier, List<Place>>((ref) {
  return PlacesNotifier();
});
