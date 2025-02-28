import 'package:flutter/material.dart';
import 'package:moments/models/dummy_place.dart';
import 'package:moments/models/place.dart';
import 'package:moments/screens/place_screen.dart';

class PlaceItem extends StatelessWidget {
  const PlaceItem({super.key, this.place, this.dummyPlace});
  final Place? place;
  final DummyPlace? dummyPlace;

  @override
  Widget build(BuildContext context) {
    void handleTap() {
      if (dummyPlace != null) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) => PlaceScreen(
                  dummyPlace: dummyPlace!,
                )));
      }

      if (place != null) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) => PlaceScreen(
                  place: place!,
                )));
      }
    }

    Widget image = Placeholder();
    if (dummyPlace != null) {
      image = Image.asset(dummyPlace!.imagePath,
          height: double.infinity, fit: BoxFit.cover);
    }

    if (place != null) {
      image =
          Image.file(place!.image, height: double.infinity, fit: BoxFit.cover);
    }

    return Padding(
      padding: const EdgeInsets.only(top: 40, bottom: 20, left: 20, right: 20),
      child: GestureDetector(
        onTap: handleTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(place != null ? place!.title : dummyPlace!.title,
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  Text(
                    place != null
                        ? place!.formattedDate
                        : dummyPlace!.formattedDate,
                    style: TextStyle(fontSize: 15, color: Colors.white60),
                  )
                ],
              ),
            ),
            Expanded(
              child: Hero(
                tag: place != null ? place!.id : dummyPlace!.id,
                child: ClipRRect(
                  clipBehavior: Clip.hardEdge,
                  borderRadius: BorderRadius.circular(20),
                  child: image,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
