// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../data/model/meal_api_model.dart';

class MealDetailsScreen extends StatelessWidget {
  final MealApiModel meal;

  const MealDetailsScreen({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: Theme.of(context).primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                meal.strMeal,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 4.0,
                      color: Colors.black,
                    ),
                    Shadow(
                      offset: Offset(0, 2),
                      blurRadius: 8.0,
                      color: Colors.black.withOpacity(0.8),
                    ),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    meal.strMealThumb,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                          Colors.black.withOpacity(0.9),
                        ],
                        stops: const [0.0, 0.7, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (meal.strCategory != null || meal.strArea != null)
                    Wrap(
                      spacing: 8,
                      children: [
                        if (meal.strCategory != null)
                          Chip(
                            label: Text(meal.strCategory!),
                            avatar: const Icon(Icons.category),
                          ),
                        if (meal.strArea != null)
                          Chip(
                            label: Text(meal.strArea!),
                            avatar: const Icon(Icons.public),
                          ),
                      ],
                    ),
                  const SizedBox(height: 24),
                  _buildSection(
                    context,
                    'Instructions',
                    Icons.menu_book,
                    Text(
                      meal.strInstructions ?? 'No instructions available',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    context,
                    'Ingredients',
                    Icons.shopping_basket,
                    _buildIngredientsList(meal),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
      BuildContext context, String title, IconData icon, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Theme.of(context).primaryColor),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: content,
          ),
        ),
      ],
    );
  }

  Widget _buildIngredientsList(MealApiModel meal) {
    List<Widget> ingredients = [];

    for (int i = 1; i <= 20; i++) {
      final ingredient = meal.getIngredient(i);
      final measure = meal.getMeasure(i);

      if (ingredient != null && ingredient.isNotEmpty) {
        ingredients.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                const Icon(Icons.fiber_manual_record, size: 8),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${measure ?? ''} $ingredient',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: ingredients,
    );
  }
}
