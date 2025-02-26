import 'package:flutter/material.dart';
import 'package:mapdown/data/dummy_places.dart';
import 'package:mapdown/widgets/favorite_places_list.dart';

class FavoritePlacesScreen extends StatelessWidget {
  const FavoritePlacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Places'),
      ),
      body: FavoritePlacesList(dummyPlaces),
    );
  }
}
