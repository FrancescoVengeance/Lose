import 'package:lose/models/Food.dart';
import 'package:lose/models/Meal.dart';
import 'package:scoped_model/scoped_model.dart';

class AppDataModel extends Model
{
  List<Meal> _meals = List.empty(growable: true);
  
  
  List<Meal> get meals => List.from(_meals);

  bool addMeal(Meal meal)
  {
    //aggiustare il controllo con il nome dello spuntino
    if(_meals.contains(meal)) //can't add two dinners
    {
      return false;
    }

    _meals.add(meal);
    return true;
  }

  void removeMeal(Meal meal)
  {
    _meals.remove(meal);
    notifyListeners();
  }
  
  void addFood(int mealIndex, Food food)
  {
    _meals.elementAt(mealIndex).addFood(food);
    notifyListeners();
  }

  void removeFood(int mealIndex, Food food)
  {
    _meals.elementAt(mealIndex).removeFood(food);
    notifyListeners();
  }
}