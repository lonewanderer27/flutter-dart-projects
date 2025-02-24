import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_coffee_lounge/data/meals.dart';

final glutenFreeMealsProvider = Provider((ref) {
  return availableMeals.where((meal) => meal.isGlutenFree == true);
});

final lactoseFreeMealsProvider = Provider((ref) {
  return availableMeals.where((meal) => meal.isLactoseFree == true);
});

final vegetarianMealsProvider = Provider((ref) {
  return availableMeals.where((meal) => meal.isVegetarian == true);
});

final veganMealsProvider = Provider((ref) {
  return availableMeals.where((meal) => meal.isVegan == true);
});