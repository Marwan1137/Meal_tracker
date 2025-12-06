// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_tracker/UI/cubit/cubit_meal.dart';
import 'package:meal_tracker/UI/cubit/cubit_meal_intent.dart';
import 'package:meal_tracker/UI/cubit/cubit_meal_state.dart';
import 'package:meal_tracker/UI/screens/add_meal_screen.dart';
import 'package:meal_tracker/UI/screens/home/widgets/meals_list.dart';
import 'package:meal_tracker/UI/screens/home/widgets/sort_button.dart';
import 'package:meal_tracker/UI/screens/home/widgets/total_calories_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Tracker'),
        centerTitle: true,
        backgroundColor: Colors.green,
        actions: const [
          SortButton(),
        ],
      ),
      body: BlocBuilder<CubitMeal, MealState>(
        builder: (context, state) {
          if (state.status == UIStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == UIStatus.success) {
            // Debug print
            for (var meal in state.meals) {
              // Debug print
            }

            // Calculate total calories
            final totalCalories =
                state.meals.fold<int>(0, (sum, meal) => sum + meal.calories);

            return Column(
              children: [
                TotalCaloriesCard(totalCalories: totalCalories),
                Expanded(
                  child: MealsList(
                    meals: state.meals,
                    onUpdate: (meal) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AddMealScreen(mealToUpdate: meal),
                        ),
                      );
                    },
                    onDelete: (id) {
                      context.read<CubitMeal>().onIntent(DeleteMealIntent(id));
                    },
                  ),
                ),
              ],
            );
          }

          return const Center(child: Text('No meals found'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddMealScreen()),
          );
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}
