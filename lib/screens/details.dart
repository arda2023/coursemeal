import 'package:flutter/material.dart';
import 'package:fluttercorsemeak/models/meal.dart';

// 1. Aus StatelessWidget wird ein StatefulWidget
class Details extends StatefulWidget {
  const Details({
    super.key,
    required this.meal,
    required this.onToggleFavorite,
    required this.favoriteMeals,
  });

  final void Function(Meal meal) onToggleFavorite;
  final Meal meal;
  final List<Meal> favoriteMeals;

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  // 2. Der State-Bereich
  @override
  Widget build(BuildContext context) {
    // 3. Da wir jetzt im State sind, müssen wir überall ein "widget." vor unsere Variablen hängen!
    final isFavorite = widget.favoriteMeals.contains(widget.meal);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.meal.title),
        actions: [
          IconButton(
            onPressed: () {
              // 4. HIER IST DIE MAGIE: Wir verpacken es in setState, damit DIESER Bildschirm sofort neu zeichnet!
              setState(() {
                widget.onToggleFavorite(widget.meal);
              });
            },
            icon: Icon(
              Icons.favorite,
              color: isFavorite ? Colors.red : Colors.white,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              widget.meal.imageUrl, // "widget." davor!
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 14),
            Text(
              "Ingredients",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),
            for (final ingredient
                in widget.meal.ingredients) // "widget." davor!
              Text(
                ingredient,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            const SizedBox(height: 24),
            Text(
              "Steps",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),
            for (final step in widget.meal.steps) // "widget." davor!
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Text(
                  step,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
