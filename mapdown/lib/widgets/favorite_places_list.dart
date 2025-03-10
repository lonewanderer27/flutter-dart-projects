import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapdown/models/favorite_place.dart';
import 'package:mapdown/screens/place_detail_screen.dart';
import 'package:mapdown/widgets/favorite_places_list_item.dart';

class FavoritePlacesList extends ConsumerWidget {
  const FavoritePlacesList(this.places, {super.key});
  final List<FavoritePlace> places;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void handlePlace(String id) {
      // get the specific place from its id
      var place = places.firstWhere((place) => place.id == id);

      // navigate to that screen
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (ctx) => PlaceDetailScreen(place)));
    }

    if (places.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Nothing has been added yet. Create one now!',
              style: TextStyle(color: Colors.white, fontSize: 18),
            )
          ],
        ),
      );
    }

    return ListView.builder(
        itemCount: places.length,
        itemBuilder: (ctx, index) =>
            FavoritePlacesListItem(places[index], handlePlace));
  }
}
