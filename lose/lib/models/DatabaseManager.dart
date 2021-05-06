import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:lose/models/Food.dart';
import 'package:lose/models/Meal.dart';
import 'package:lose/models/User.dart' as MyUser;

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

  void deleteMeal(Meal meal)
  {
    _databaseReference.child(meal.id).remove();
  }

  void deleteFood(Food food, Meal meal)
  {
    _databaseReference.child('${meal.id}/${food.id}').remove();
  }

  Future<bool> register(String mail, String password) async
  {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: mail,
          password: password
      );

      return true;

    } on FirebaseAuthException catch (e)
    {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }

    return false;
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
       meals.add(meal);
      });
    }

    return meals;
  }

  void _buildFoodList(value, Meal meal)
  {
    for(String key in value.keys)
    {
      try
      {
        String name = value[key]['name'].toString();
        double kCal = double.parse(value[key]['kCal'].toString());
        double fats = double.parse(value[key]['fats'].toString());
        double carbohydrates = double.parse(value[key]['carbohydrates'].toString());
        double proteins = double.parse(value[key]['proteins'].toString());
        double salt = double.parse(value[key]['salt'].toString());
        double calcium = double.parse(value[key]['calcium'].toString());
        double fibers = double.parse(value[key]['fibers'].toString());
        String imagePath = value[key]['imagePath'].toString();

        Food temp = Food(name:name, kCal: kCal, fats: fats, carbohydrates: carbohydrates,
            proteins: proteins, salt: salt, calcium: calcium, fibers: fibers, imagePath: imagePath
        );
        temp.setId(key.toString());
        meal.addFood(temp);
      }
      catch(error)
      {
        print('_buildFoodList $key');
        print(error);
      }
    }
  }
}