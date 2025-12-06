// ignore_for_file: unused_local_variable, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_tracker/domain/entity/meal.dart';
import 'package:meal_tracker/UI/screens/home/widgets/meal_card.dart';
import 'package:meal_tracker/core/utils/date_formatter.dart';

void main() {
  late Meal testMeal;

  setUp(() {
    testMeal = Meal(
      id: '1',
      name: 'Test Meal',
      type: MealType.breakfast,
      dateTime: DateTime(2024, 1, 1, 8, 0),
      calories: 300,
    );
  });

  group('MealCard Tests', () {
    testWidgets('should display meal information correctly', (tester) async {
      bool updateCalled = false;
      bool deleteCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MealCard(
              meal: testMeal,
              onUpdate: (_) => updateCalled = true,
              onDelete: (_) => deleteCalled = true,
            ),
          ),
        ),
      );

      // Verify meal name is displayed
      expect(find.text('Test Meal'), findsOneWidget);

      // Verify date is displayed
      expect(
        find.text(DateFormatter.formatDateTime(testMeal.dateTime)),
        findsOneWidget,
      );

      // Verify calories are displayed
      expect(find.text('300 cal'), findsOneWidget);

      // Verify meal type icon is displayed
      expect(find.byIcon(Icons.breakfast_dining), findsOneWidget);
    });

    testWidgets('should have correct styling', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MealCard(
              meal: testMeal,
              onUpdate: (_) {},
              onDelete: (_) {},
            ),
          ),
        ),
      );

      // Verify name text style
      final nameText = tester.widget<Text>(
        find.text('Test Meal'),
      );
      expect(nameText.style?.fontSize, 16);
      expect(nameText.style?.fontWeight, FontWeight.bold);

      // Verify calories container styling
      final caloriesContainer = find.ancestor(
        of: find.text('300 cal'),
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is Container &&
              widget.decoration is BoxDecoration &&
              (widget.decoration as BoxDecoration).color ==
                  Colors.orange.withOpacity(0.1),
        ),
      );
      expect(caloriesContainer, findsOneWidget);
    });

    testWidgets('should call onUpdate when update action is pressed',
        (tester) async {
      Meal? updatedMeal;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MealCard(
              meal: testMeal,
              onUpdate: (meal) => updatedMeal = meal,
              onDelete: (_) {},
            ),
          ),
        ),
      );

      // Slide to reveal actions
      await tester.drag(find.byType(Slidable), const Offset(-500, 0));
      await tester.pumpAndSettle();

      // Find and tap the update action
      final updateAction = find.byWidgetPredicate(
        (widget) =>
            widget is SlidableAction &&
            widget.icon == Icons.edit &&
            widget.backgroundColor == Colors.blue,
      );
      expect(updateAction, findsOneWidget);

      await tester.tap(updateAction);
      await tester.pumpAndSettle();

      expect(updatedMeal, equals(testMeal));
    });

    testWidgets('should call onDelete when delete action is pressed',
        (tester) async {
      String? deletedId;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MealCard(
              meal: testMeal,
              onUpdate: (_) {},
              onDelete: (id) => deletedId = id,
            ),
          ),
        ),
      );

      // Slide to reveal actions
      await tester.drag(find.byType(Slidable), const Offset(-500, 0));
      await tester.pumpAndSettle();

      // Find and tap the delete action
      final deleteAction = find.byWidgetPredicate(
        (widget) =>
            widget is SlidableAction &&
            widget.icon == Icons.delete &&
            widget.backgroundColor == Colors.red,
      );
      expect(deleteAction, findsOneWidget);

      await tester.tap(deleteAction);
      await tester.pumpAndSettle();

      expect(deletedId, equals(testMeal.id));
    });

    testWidgets('should display correct icon and color for each meal type',
        (tester) async {
      final mealTypes = {
        MealType.breakfast: (Icons.breakfast_dining, Colors.orange),
        MealType.lunch: (Icons.lunch_dining, Colors.green),
        MealType.dinner: (Icons.dinner_dining, Colors.blue),
        MealType.snack: (Icons.cookie, Colors.purple),
        MealType.dessert: (Icons.icecream, Colors.pink),
      };

      for (final entry in mealTypes.entries) {
        final mealType = entry.key;
        final (expectedIcon, expectedColor) = entry.value;

        final meal = testMeal.copywith(type: mealType);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MealCard(
                meal: meal,
                onUpdate: (_) {},
                onDelete: (_) {},
              ),
            ),
          ),
        );

        expect(find.byIcon(expectedIcon), findsOneWidget);

        final iconWidget = tester.widget<Icon>(find.byIcon(expectedIcon));
        expect(iconWidget.color, expectedColor);

        await tester.pumpAndSettle();
      }
    });
  });
}
