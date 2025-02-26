import 'package:flutter/material.dart';
import 'package:mapdown/models/favorite_place.dart';

class FavoritePlacesListItem extends StatelessWidget {
  const FavoritePlacesListItem(this.place, this.handleOnPlace, {super.key});
  final FavoritePlace place;
  final void Function(String id) handleOnPlace;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        handleOnPlace(place.id);
      },
      title: Text(place.name),
    );
  }
}
