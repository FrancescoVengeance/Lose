import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:lose/models/Food.dart';
import 'package:lose/models/Meal.dart';
import 'package:lose/models/User.dart';
import 'package:scoped_model/scoped_model.dart';

class AppDataModel extends Model
{
  List<Meal> _meals = List.empty(growable: true);
  final User user = User(username: 'Francuzzu1', mail: 'francesco.esposity@gmail.com');
  DatabaseReference database;// = FirebaseDatabase(app: _firebaseApp).instance.reference();
  final FirebaseApp _firebaseApp;
  List<Meal> get meals => List.from(_meals);

  AppDataModel(this._firebaseApp)
  {
    database = FirebaseDatabase(app: _firebaseApp).reference();
  }

  bool addMeal(Meal meal)
  {
    //aggiustare il controllo con il nome dello spuntino
    if(_meals.contains(meal)) //can't add two dinners
    {
      return false;
    }

    _meals.add(meal);
    database.child('meal').set({'chiave', 'valore'});
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
    notifyListeners();
  }

  void removeFood(int mealIndex, Food food)
  {
    _meals.elementAt(mealIndex).removeFood(food);
    notifyListeners();
  }
}