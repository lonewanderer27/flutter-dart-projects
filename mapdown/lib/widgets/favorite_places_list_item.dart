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
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Image.file(place.image,
            fit: BoxFit.cover, height: 40, width: 40),
      ),
      title: Text(place.name),
    );
  }
}
