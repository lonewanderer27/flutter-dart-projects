import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:meals_coffee_lounge/data/categories.dart';
import 'package:meals_coffee_lounge/models/category.dart';
import 'package:meals_coffee_lounge/models/meal.dart';
import 'package:meals_coffee_lounge/screens/meals_screen.dart';
import 'package:meals_coffee_lounge/widgets/category_grid_item.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key, required this.availableMeals});
  final List<Meal> availableMeals;

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  void _selectCategory(BuildContext context, Category category) {
    Navigator.push(context, MaterialPageRoute(builder: (builder) {
      // filter the food items based on its category
      var filteredMeals = widget.availableMeals
          .where((meal) => meal.categories.contains(category.id))
          .toList();
      return MealsScreen(meals: filteredMeals, title: category.title);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
            itemCount: availableCategories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20),
            itemBuilder: (BuildContext ctx, int index) {
              return AnimationConfiguration.staggeredGrid(
                  position: index,
                  columnCount: 2,
                  child: SlideAnimation(
                      delay: Duration(milliseconds: 50),
                      child: SlideAnimation(
                          delay: Duration(milliseconds: 100),
                          child: CategoryGridItem(
                              category: availableCategories[index],
                              changeCategory: (category) {
                                _selectCategory(context, category);
                              }))));
            }),
      ),
    );
  }
}
