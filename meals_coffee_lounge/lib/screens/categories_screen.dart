import 'package:flutter/material.dart';
import 'package:meals_coffee_lounge/data/categories.dart';
import 'package:meals_coffee_lounge/data/meals.dart';
import 'package:meals_coffee_lounge/models/category.dart';
import 'package:meals_coffee_lounge/screens/meals_screen.dart';
import 'package:meals_coffee_lounge/widgets/category_grid_item.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  void _selectCategory(BuildContext context, Category category) {
    Navigator.push(context, MaterialPageRoute(builder: (builder) {
      // filter the food items based on its category
      var filteredMeals = availableMeals
          .where((meal) => meal.categories.contains(category.id))
          .toList();
      return MealsScreen(meals: filteredMeals, title: category.title);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return GridView(
      padding: EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20),
      children: [
        ...availableCategories.map((category) => CategoryGridItem(
              category: category,
              changeCategory: (category) {
                _selectCategory(context, category);
              },
            ))
      ],
    );
  }
}
