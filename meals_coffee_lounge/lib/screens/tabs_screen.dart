import 'package:flutter/material.dart';
import 'package:meals_coffee_lounge/data/meals.dart';
import 'package:meals_coffee_lounge/screens/categories_screen.dart';
import 'package:meals_coffee_lounge/screens/meals_screen.dart';
import 'package:meals_coffee_lounge/widgets/main_drawer.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPage = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPage = index;
    });
  }
  void _setScreen(String identifier) {
    switch (identifier) {
      case 'filters':
        {}
        break;
      case 'meals':
        {
          Navigator.of(context).pop();
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = CategoriesScreen();
    String activePageTitle = 'Categories';

    if (_selectedPage == 1) {
      activePage = MealsScreen(meals: availableMeals);
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
