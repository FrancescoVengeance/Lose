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
  
  DatabaseReference addFood(Food food, String mealId)
  {
    DatabaseReference id = _databaseReference.child('$mealId/').push();
    id.set(food.toJson());
    return id;
  }

  void updateMeal(Meal meal)
  {
    _databaseReference.child(meal.id).update(meal.toJson());
  }

  Future<List<Meal>> fetchMeals() async
  {
    DataSnapshot snapshot = await _databaseReference.child('meals/').once();
    List<Meal> meals = List.empty(growable: true);

    if(snapshot.value != null)
    {
      snapshot.value.forEach((key, value) {
       Meal meal = Meal.noParams();
       meal.setId(key);
       meal.setMealtype(value['type']);
       _buildFoodList(value, meal);
       print('Key: $key value: $value');
      });
    }

    return [];
  }

  void _buildFoodList(value, Meal meal)
  {
    for(dynamic key in value.keys)
    {
      for(dynamic key2 in value[key].keys)
      {
        print(value[key][key2]); //TODO da aggiustare
        //meal.addFood(_generateFood(velue[key][key2]));
      }
    }
  }
}