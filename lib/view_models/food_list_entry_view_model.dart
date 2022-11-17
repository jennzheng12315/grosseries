import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_application_1/models/list_food_entry.dart';
import 'package:flutter_application_1/models/food_item.dart';
import 'package:flutter_application_1/view_models/food_item_view_model.dart';

final Random _random = Random();
const int max = 1000000000;

final List<ListFoodEntry> initialData = List.generate(
  10,
  (index) => ListFoodEntry(
      entryId: _random.nextInt(max),
      foodId: index,
      storage: "Fridge",
      quantity: 3,
      owner: "Jennifer Zheng",
      dateAdded: DateTime.now()),
);

class FoodListEntryViewModel with ChangeNotifier {
  final List<ListFoodEntry> _foodItems = initialData;

  List<ListFoodEntry> get foodItems => _foodItems;
  set quantity(int q) => {quantity = q};

  FoodItem? getFoodItem(foodId) {
    return FoodItemViewModel.getFoodItem(foodId);
  }

  ListFoodEntry? getListFoodEntry(int entryId) {
    for (var item in initialData) {
      if (item.entryId == entryId) return item;
    }
    return null;
  }

  void addFoodItemEntry(
      int id, String storage, int quantity, String owner, DateTime dateAdded) {
    _foodItems.add(
      ListFoodEntry(
        entryId: _random.nextInt(max),
        foodId: id,
        storage: storage,
        quantity: quantity,
        owner: owner,
        dateAdded: dateAdded,
      ),
    );
  }

  void removeFoodItemEntry(int entryId) {
    for (int i = 0; i < _foodItems.length; i++) {
      if (_foodItems[i].entryId == entryId) {
        _foodItems.removeAt(i);
        notifyListeners();

        break;
      }
    }
  }

  static String getInitials(ListFoodEntry listFoodEntry) {
    var buffer = StringBuffer();
    var split = listFoodEntry.owner.split(' ');
    for (var i = 0; i < split.length; i++) {
      buffer.write(split[i][0].toUpperCase());
    }

    return buffer.toString();
  }

  String expirationString(int entryId) {
    ListFoodEntry? listFoodEntry = getListFoodEntry(entryId);
    FoodItem? foodItem = FoodItemViewModel.getFoodItem(listFoodEntry!.foodId);
    Duration timePassed = DateTime.now().difference(listFoodEntry.dateAdded);

    if (timePassed.inDays == foodItem!.daysToExpire) {
      return "Expires Today";
    }

    if (timePassed.inDays > foodItem.daysToExpire) {
      return "Expired by ${timePassed.inDays - foodItem.daysToExpire} Day";
    }

    if (foodItem.daysToExpire - timePassed.inDays > 1) {
      return "${foodItem.daysToExpire - timePassed.inDays} days left";
    } else {
      return "${foodItem.daysToExpire - timePassed.inDays} day left";
    }
  }
}