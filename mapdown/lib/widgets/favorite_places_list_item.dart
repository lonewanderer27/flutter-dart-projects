import 'package:flutter/material.dart';
import 'package:mapdown/models/favorite_place.dart';

class FavoritePlacesListItem extends StatelessWidget {
  const FavoritePlacesListItem(this.place, {super.key});
  final FavoritePlace place;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(place.name),
    );
  }
}
