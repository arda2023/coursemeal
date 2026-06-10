import 'package:flutter/material.dart';
import 'package:fluttercorsemeak/data/dummy_data.dart';
import 'package:fluttercorsemeak/models/category.dart';
import 'package:fluttercorsemeak/models/meal.dart';
import 'package:fluttercorsemeak/screens/meals.dart';
import 'package:fluttercorsemeak/widgets/category_grid_item.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({
    super.key,
    required this.onToggleFavorite,
    required this.favoriteMeals,
  });

  final void Function(Meal meal) onToggleFavorite;
  final List<Meal>
  favoriteMeals; // 👈 2. NEU: Das ist die Tasche, in der die Liste gespeichert wird

  void _selectCategory(BuildContext context, Category category) {
    final filteredMeals = dummyMeals
        .where((meal) => meal.categories.contains(category.id))
        .toList();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => MealsScreen(
          title: category.title,
          meals: filteredMeals,
          onToggleFavorite: onToggleFavorite,
          favoriteMeals: favoriteMeals,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      children: [
        for (final category in availableCategories)
          CategoryGridItem(
            category: category,
            onSelectCategory: () {
              _selectCategory(context, category);
            },
          ),
      ],
    );
  }
}
