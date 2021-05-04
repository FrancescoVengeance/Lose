import 'package:lose/models/DatabaseManager.dart';
import 'package:lose/models/Food.dart';
import 'package:lose/models/Meal.dart';
import 'package:lose/models/User.dart';
import 'package:scoped_model/scoped_model.dart';

class AppDataModel extends Model
{
  List<Meal> _meals = List.empty(growable: true);
  final User user = User(username: 'Francuzzu1', mail: 'francesco.esposity@gmail.com');

  AppDataModel()
  {
    fetchMeals();
  }

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
    notifyListeners();
  }
  
  void addFood(int mealIndex, Food food)
  {
    _meals.elementAt(mealIndex).addFood(food);
    food.id = DatabaseManager.getInstance().addFood(food, _meals.elementAt(mealIndex).id);
    notifyListeners();
  }

  void removeFood(int mealIndex, Food food)
  {
    _meals.elementAt(mealIndex).removeFood(food);
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
    await DatabaseManager.getInstance().fetchMeals();
  }
}