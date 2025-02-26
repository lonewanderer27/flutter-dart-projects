import 'dart:io';

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
          children: [
            Image.file(place.image),
            SizedBox(height: 20),
            Text(
              place.name,
              style: TextStyle(color: Colors.white, fontSize: 20),
            )
          ],
        ),
      ),
    );
  }
}
