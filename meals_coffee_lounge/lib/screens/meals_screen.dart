import 'package:flutter/material.dart';
import 'package:meals_coffee_lounge/models/meal.dart';

class MealsScreen extends StatelessWidget {
  const MealsScreen({super.key, required this.meals, required this.title});
  final List<Meal> meals;
  final String title;

  @override
  Widget build(BuildContext context) {
    Widget content = Center(
      child: Column(
        children: [
          Text('Uh oh... Nothing is here'),
          SizedBox(
            height: 10,
          ),
          Text(
            'Try selecting a different category.',
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Theme.of(context).colorScheme.onBackground),
          )
        ],
      ),
    );

    if (meals.isNotEmpty) {
      content = ListView.builder(
          itemCount: meals.length,
          itemBuilder: (ctx, index) => Text(
                meals[index].title,
                style: TextStyle(color: Colors.white),
              ));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: content,
    );
  }
}
