import 'package:firebase_database/firebase_database.dart';
import 'package:lose/models/Food.dart';
import 'package:lose/models/Meal.dart';

class DatabaseManager
{
  static DatabaseManager _instance;
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();

  DatabaseManager._createInstance();

  static DatabaseManager getInstance()
  {
    if(_instance == null)
    {
      _instance = DatabaseManager._createInstance();
    }
    return _instance;
  }

  DatabaseReference addMeal(Meal meal)
  {
    //String date = '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}';
    //database.push().child('meals/').push().set('qualcosa');
    /*DatabaseReference id = _databaseReference.child('days').push();
    id.set({'date' : date});
    id = _databaseReference.child('days/meals').push();
    id.set(meal.toJson());*/

    DatabaseReference id = _databaseReference.child('meals').push();
    id.set(meal.toJson());
    return id;
  }
  
  DatabaseReference addFood(Food food, DatabaseReference mealId)
  {
    DatabaseReference id = _databaseReference.child('meals/${mealId.key}/foods').push();
    id.set(food.toJson());
    return id;
  }

  void updateMeal(Meal meal)
  {
    meal.id.update(meal.toJson());
  }
}