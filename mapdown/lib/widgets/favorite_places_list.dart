import 'package:flutter/material.dart';
import 'package:mapdown/models/favorite_place.dart';
import 'package:mapdown/widgets/favorite_places_list_item.dart';

class FavoritePlacesList extends StatelessWidget {
  const FavoritePlacesList(this.places, {super.key});
  final List<FavoritePlace> places;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: places.length,
        itemBuilder: (ctx, index) => FavoritePlacesListItem(places[index]));
  }
}
