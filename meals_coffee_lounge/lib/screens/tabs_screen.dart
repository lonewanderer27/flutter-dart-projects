import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_coffee_lounge/data/meals.dart';
import 'package:meals_coffee_lounge/enums/filter.dart';
import 'package:meals_coffee_lounge/providers/favorites_provider.dart';
import 'package:meals_coffee_lounge/providers/filters_provider.dart';
import 'package:meals_coffee_lounge/screens/categories_screen.dart';
import 'package:meals_coffee_lounge/screens/filters_screen.dart';
import 'package:meals_coffee_lounge/screens/meals_screen.dart';
import 'package:meals_coffee_lounge/widgets/main_drawer.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPage = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPage = index;
    });
  }

  void _setScreen(String identifier) {
    Navigator.of(context).pop();

    switch (identifier) {
      case 'filters':
        {
          Navigator.of(context).push<Map<Filter, bool>>(
              MaterialPageRoute(builder: (ctx) => FiltersScreen()));
        }
        break;
      case 'meals':
        {
          // Navigator.of(context).pop();
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredMeals = ref.watch(filteredMealsProvider);
    Widget activePage = CategoriesScreen(availableMeals: filteredMeals);
    String activePageTitle = 'Categories';

    if (_selectedPage == 1) {
      final favoriteMealsId = ref.watch(favoriteMealsProvider);

      // get the meal objects
      final favoriteMeals = availableMeals
          .where((meal) => favoriteMealsId.contains(meal.id))
          .toList();

      activePage = MealsScreen(meals: favoriteMeals);
      activePageTitle = 'Your Favorites';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      drawer: MainDrawer(onSelectScreen: _setScreen),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPage,
        onTap: _selectPage,
        items: [
          const BottomNavigationBarItem(
              icon: Icon(Icons.set_meal), label: 'Categories'),
          const BottomNavigationBarItem(
              icon: Icon(Icons.star), label: 'Favorites')
        ],
      ),
    );
  }
}
