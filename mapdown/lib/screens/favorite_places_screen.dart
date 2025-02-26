import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapdown/providers/favorite_places_provider.dart';
import 'package:mapdown/screens/add_places_screen.dart';
import 'package:mapdown/widgets/favorite_places_list.dart';

class FavoritePlacesScreen extends ConsumerWidget {
  const FavoritePlacesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritePlaces = ref.watch(favoritePlacesProvider);
    void handleAdd() {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (ctx) => AddPlacesScreen()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Places'),
      ),
      body: FavoritePlacesList(favoritePlaces),
      floatingActionButton: FloatingActionButton(
        onPressed: handleAdd,
        child: const Icon(Icons.add),
      ),
    );
  }
}
