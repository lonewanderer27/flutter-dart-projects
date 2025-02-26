import 'package:flutter/material.dart';
import 'package:mapdown/models/favorite_place.dart';

class PlaceDetailScreen extends StatelessWidget {
  const PlaceDetailScreen(this.place, {super.key});
  final FavoritePlace place;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place.name),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              place.name,
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
