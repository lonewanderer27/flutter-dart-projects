import 'package:flutter/material.dart';
import 'package:meals_coffee_lounge/models/ingredient.dart';

class IngredientItem extends StatelessWidget {
  const IngredientItem(this.ingredient, {super.key, required});
  final Ingredient ingredient;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Padding(
          padding: EdgeInsets.all(7),
          child: Image.asset(ingredient.icon!, color: Colors.white),
        ),
        title: Text(ingredient.title),
        trailing: Text(ingredient.amount));
  }
}
