import 'package:flutter/material.dart';
import 'package:fluttercorsemeak/data/dummy_data.dart';
import 'package:fluttercorsemeak/models/meal.dart';
import 'package:fluttercorsemeak/screens/categories.dart';
import 'package:fluttercorsemeak/screens/filters.dart';
import 'package:fluttercorsemeak/screens/meals.dart';
import 'package:fluttercorsemeak/widgets/main_drawer.dart';

const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegan: false,
  Filter.vegetarian: false,
};

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

  void _setScreen(String identifier) async {
    Navigator.of(context).pop();

    if (identifier == "filters") {
      final result = await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (ctx) => FitersScreen(currentFilters: _selectedFilters),
        ),
      );

      // HIER IST DIE KORREKTUR: setState hinzugefügt, damit die Filter greifen!
      setState(() {
        _selectedFilters = result ?? kInitialFilters;
      });
    }
  }

  List<Meal> favMeals = [];
  Map<Filter, bool> _selectedFilters = kInitialFilters;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _toggleMealFavoriteStatus(Meal meal) {
    setState(() {
      if (favMeals.contains(meal)) {
        favMeals.remove(meal);
        _showInfoMessage("Meal no longer favorite");
      } else {
        favMeals.add(meal);
        _showInfoMessage("Marked as favorite");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final availableMeals = dummyMeals.where((meal) {
      if (_selectedFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
        return false;
      }
      if (_selectedFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
        return false;
      }
      if (_selectedFilters[Filter.vegetarian]! && !meal.isVegetarian) {
        return false;
      }
      if (_selectedFilters[Filter.vegan]! && !meal.isVegan) {
        return false;
      }
      return true;
    }).toList();

    Widget activePage = CategoriesScreen(
      onToggleFavorite: _toggleMealFavoriteStatus,
      favoriteMeals: favMeals,
      availableMeals: availableMeals,
    );
    var activePageTitle = "Categories";

    if (_selectedPageIndex == 1) {
      activePage = MealsScreen(
        meals: favMeals,
        onToggleFavorite: _toggleMealFavoriteStatus,
        favoriteMeals: favMeals,
      );
      activePageTitle = "Your favorites";
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
