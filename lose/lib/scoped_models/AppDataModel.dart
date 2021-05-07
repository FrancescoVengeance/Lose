import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:lose/models/DatabaseManager.dart';
import 'package:lose/models/Food.dart';
import 'package:lose/models/Meal.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scoped_model/scoped_model.dart';

class AppDataModel extends Model
{
  List<Meal> _meals = List.empty(growable: true);
  bool _isLoading = false;
  User user;

  bool get isLoading => _isLoading;
  List<Meal> get meals => List.from(_meals);


  Future<void> autologin() async
  {
    _isLoading = true;
    notifyListeners();

    user = FirebaseAuth.instance.currentUser;
    await fetchMeals();

    _isLoading = false;
    notifyListeners();
  }

  Future<Map<bool, String>> register(String mail, String password) async
  {
    _isLoading = true;
    notifyListeners();

    Map<User, String> data;
    data = await DatabaseManager.getInstance().register(mail, password);
    user = data.keys.first;
    if(user != null)
    {
      await fetchMeals();
      _isLoading = false;
      notifyListeners();
      return {true : " "};
    }

    _isLoading = false;
    notifyListeners();
    return {false : data.values.first};
  }

  Future<Map<bool, String>> login(String mail, String password) async
  {
    _isLoading = true;
    notifyListeners();

    Map<User, String> data;
    data = await DatabaseManager.getInstance().login(mail, password);
    user = data.keys.first;
    if(user != null)
    {
      await fetchMeals();
      _isLoading = false;
      notifyListeners();
      return {true : ""};
    }

    _isLoading = false;
    notifyListeners();
    return {false : data.values.first};
  }

  Future<void> logOut() async
  {
    await FirebaseAuth.instance.signOut();
  }

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
    meal.setId(DatabaseManager.getInstance().addMeal(meal, user.uid).key);
    notifyListeners();
    return true;
  }

  void removeMeal(Meal meal)
  {
    _meals.remove(meal);
    DatabaseManager.getInstance().deleteMeal(meal, user.uid);
    notifyListeners();
  }
  
  void addFood(int mealIndex, Food food)
  {
    _meals.elementAt(mealIndex).addFood(food);
    food.setId(DatabaseManager.getInstance().addFood(food, _meals.elementAt(mealIndex).id, user.uid).key);
    notifyListeners();
  }

  void removeFood(int mealIndex, Food food)
  {
    _meals.elementAt(mealIndex).removeFood(food);
    DatabaseManager.getInstance().deleteFood(food, _meals.elementAt(mealIndex), user.uid);
    notifyListeners();
  }

  void updateMeal(Meal meal, int mealIndex)
  {
    meal.setMealtype('cazzarola'); //TODO
    _meals[mealIndex] = meal;
    DatabaseManager.getInstance().updateMeal(meal, user.uid);
    notifyListeners();
  }

  Future<void> fetchMeals() async
  {
    _meals = await DatabaseManager.getInstance().fetchMeals(user.uid);
  }
}