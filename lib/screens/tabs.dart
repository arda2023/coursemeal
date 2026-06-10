import 'package:flutter/material.dart';
import 'package:fluttercorsemeak/models/meal.dart';
import 'package:fluttercorsemeak/screens/categories.dart';
import 'package:fluttercorsemeak/screens/filters.dart';
import 'package:fluttercorsemeak/screens/meals.dart';
import 'package:fluttercorsemeak/widgets/main_drawer.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;
  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _setScreen(String identifier) {
    Navigator.of(context).pop();

    if (identifier == "filters") {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (ctx) => const FitersScreen()));
    }
  }

  List<Meal> favMeals = [];

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _toggleMealFavoriteStatus(Meal meal) {
    setState(() {
      if (favMeals.contains(meal)) {
        favMeals.remove(meal);
        _showInfoMessage("Meal no longe");
      } else {
        favMeals.add(meal);
        _showInfoMessage("marked as");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = CategoriesScreen(
      onToggleFavorite: _toggleMealFavoriteStatus,
      favoriteMeals: favMeals,
    );
    var activePageTitle = "Categories";

    if (_selectedPageIndex == 1) {
      activePage = MealsScreen(
        meals: favMeals,
        onToggleFavorite: _toggleMealFavoriteStatus,
        favoriteMeals: favMeals,
      );
      activePageTitle = "Your favortes";
    }
    return Scaffold(
      appBar: AppBar(title: Text(activePageTitle)),
      drawer: MainDrawer(onSelectScreen: _setScreen),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: "Categories",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: "Favorites"),
        ],
      ),
    );
  }
}
