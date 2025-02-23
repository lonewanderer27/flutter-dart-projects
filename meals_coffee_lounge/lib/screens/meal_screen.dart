import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_coffee_lounge/models/meal.dart';
import 'package:meals_coffee_lounge/providers/favorites_provider.dart';
import 'package:meals_coffee_lounge/widgets/ingredient_item.dart';
import 'package:transparent_image/transparent_image.dart';

// if we come from StatelessWidget
// therefore to use riverpod, we need to extend from ConsumerWidget instead
class MealScreen extends ConsumerWidget {
  const MealScreen({super.key, required this.meal});
  final Meal meal;

  @override
  // ConsumerWidget automatically pass a WidgetRef
  // to the build method of this ConsumerWidget class
  Widget build(BuildContext context, WidgetRef ref) {
    // we used watch for now as using toggling meal favorite status
    // doesn't seem to affect the isFavorite bool value 
    // unless we reload the component / out then in
    final isFavorite = ref.watch(favoriteMealsProvider).contains(meal.id);

    void showInfoMessage(String message) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }

    void markAsFavorite() {
      bool added = ref
          .read(favoriteMealsProvider.notifier)
          .toggleMealFavoriteStatus(meal.id);

      if (added) {
        showInfoMessage('Marked as favorite');
        return;
      }

      showInfoMessage('Meal is no longer a favorite');
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(meal.title),
          actions: [
            IconButton(
                onPressed: markAsFavorite,
                icon: Icon(isFavorite ? Icons.star : Icons.star_outline))
          ],
        ),
        body: Column(
          children: [
            // Meal image with a fixed height
            SizedBox(
              height: 225,
              width: double.infinity,
              child: FadeInImage(
                placeholder: MemoryImage(kTransparentImage),
                image: NetworkImage(meal.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const TabBar(
                        tabs: [Tab(text: 'Ingredients'), Tab(text: 'Steps')]),
                    // TabBarView inside Expanded
                    Expanded(
                      child: TabBarView(
                        children: [
                          ListView(
                            padding: const EdgeInsets.all(20),
                            children: meal.ingredients.map((ingredient) {
                              return IngredientItem(ingredient);
                            }).toList(),
                          ),
                          ListView(
                            padding: const EdgeInsets.all(20),
                            children: meal.steps.map((step) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 3, horizontal: 5),
                                child: Text(step,
                                    style:
                                        const TextStyle(color: Colors.white)),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Meal tags (gluten-free, vegan, etc.)
                    Wrap(
                      spacing: 10,
                      children: [
                        if (meal.isGlutenFree)
                          const Chip(label: Text('Gluten Free')),
                        if (meal.isLactoseFree)
                          const Chip(label: Text('Lactose Free')),
                        if (meal.isVegan) const Chip(label: Text('Vegan')),
                        if (meal.isVegetarian)
                          const Chip(label: Text('Vegetarian')),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
