import 'package:flutter/material.dart';
import 'package:moments/models/dummy_place.dart';
import 'package:moments/models/place.dart';

class PlaceScreen extends StatelessWidget {
  const PlaceScreen({super.key, this.dummyPlace, this.place});
  final Place? place;
  final DummyPlace? dummyPlace;

  @override
  Widget build(BuildContext context) {
    Widget body = Placeholder();

    if (place != null) {
      body = Hero(
          tag: 'image-preview',
          child: Image.file(
            place!.image,
            height: double.infinity,
            fit: BoxFit.cover,
          ));
    }

    if (dummyPlace != null) {
      body = Hero(
        tag: 'image-preview',
        child: Image.asset(
          dummyPlace!.imagePath,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black54,
      body: body,
    );
  }
}
