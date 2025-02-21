import 'package:flutter/material.dart';
import 'package:meals_coffee_lounge/models/meal.dart';
import 'package:meals_coffee_lounge/widgets/meal_item/meal_item_trait.dart';
import 'package:transparent_image/transparent_image.dart';

class MealScreen extends StatelessWidget {
  const MealScreen({super.key, required this.meal});
  final Meal meal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(meal.title),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              FadeInImage(
                  placeholder: MemoryImage(kTransparentImage),
                  image: NetworkImage(meal.imageUrl)),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        MealItemTrait(
                          icon: Icons.schedule,
                          label: '${meal.duration.toString()} min',
                        ),
                        SizedBox(width: 10),
                        MealItemTrait(
                          icon: Icons.work_outline,
                          label: meal.complexityText,
                        ),
                        SizedBox(width: 10),
                        MealItemTrait(
                          icon: Icons.attach_money,
                          label: meal.affordabilityText,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        children: [
                          if (meal.isGlutenFree)
                            Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Chip(label: Text('Gluten Free')),
                            ),
                          if (meal.isLactoseFree)
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Chip(label: Text('Lactose Free')),
                            ),
                          if (meal.isVegan)
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Chip(label: Text('Vegan')),
                            ),
                          if (meal.isVegetarian)
                            Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Chip(label: Text('Vegetarian'))),
                        ],
                      ),
                    ),
                    Text(
                      'Ingredients',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    ...(meal.ingredients.map((ingredient) => Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 3, horizontal: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                ingredient.title,
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                ingredient.amount,
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                        ))),
                    SizedBox(height: 30),
                    Text('Steps',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                    ...(meal.steps.map((step) => Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 3, horizontal: 5),
                          child: Column(
                            children: [
                              Text(
                                step,
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                        )))
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
