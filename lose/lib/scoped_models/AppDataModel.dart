import 'dart:io';

import 'package:lose/models/DatabaseManager.dart';
import 'package:lose/models/Food.dart';
import 'package:lose/models/Meal.dart';
import 'package:lose/models/User.dart';
import 'package:scoped_model/scoped_model.dart';

class AppDataModel extends Model
{
  List<Meal> _meals = List.empty(growable: true);
  final User user = User(username: 'Francuzzu1', mail: 'francesco.esposity@gmail.com');
  bool _isLoading;


  bool get isLoading => _isLoading;
  List<Meal> get meals => List.from(_meals);

  bool addMeal(Meal meal)
  {
    //aggiustare il controllo con il nome dello spuntino
    for(Meal m in _meals)
    {
      if(m.mealType == meal.mealType)
      {
        return false;
      }
    }

    _meals.add(meal);
    meal.setId(DatabaseManager.getInstance().addMeal(meal).key);
    notifyListeners();
    return true;
  }

  void removeMeal(Meal meal)
  {
    _meals.remove(meal);
    DatabaseManager.getInstance().deleteMeal(meal);
    notifyListeners();
  }
  
  void addFood(int mealIndex, Food food)
  {
    _meals.elementAt(mealIndex).addFood(food);
    food.setId(DatabaseManager.getInstance().addFood(food, _meals.elementAt(mealIndex).id).key);
    notifyListeners();
  }

  void removeFood(int mealIndex, Food food)
  {
    _meals.elementAt(mealIndex).removeFood(food);
    DatabaseManager.getInstance().deleteFood(food, _meals.elementAt(mealIndex));
    notifyListeners();
  }

  void updateMeal(Meal meal, int mealIndex)
  {
    meal.setMealtype('cazzarola'); //TODO
    _meals[mealIndex] = meal;
    DatabaseManager.getInstance().updateMeal(meal);
    notifyListeners();
  }

  void fetchMeals() async
  {
    _isLoading = true;
    notifyListeners();

    _meals = await DatabaseManager.getInstance().fetchMeals();

    _isLoading = false;
    notifyListeners();
  }
}