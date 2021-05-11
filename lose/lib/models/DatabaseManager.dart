import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:lose/models/DateFormat.dart';
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

  DatabaseReference addMeal(Meal meal, String userUID)
  {
    DatabaseReference id = _databaseReference.child('$userUID/${DateFormat.dateToString(DateTime.now())}/meals').push();
    id.set(meal.toJson());
    return id;
  }
  
  DatabaseReference addFood(Food food, String mealId, String userUID)
  {
    DatabaseReference id = _databaseReference.child('$userUID/${DateFormat.dateToString(DateTime.now())}/$mealId/').push();
    id.set(food.toJson());
    return id;
  }

  void updateMeal(Meal meal, String userUID, String date)
  {
    _databaseReference.child("$userUID/$date/${meal.id}").update(meal.toJson());
  }

  void deleteMeal(Meal meal, String userUID, String date)
  {
    _databaseReference.child("$userUID/$date/${meal.id}").remove();
  }

  void deleteFood(Food food, Meal meal, String userUID, String date)
  {
    _databaseReference.child('$userUID/$date/${meal.id}/${food.id}').remove();
  }

  Future<Map<User, String>> register(String mail, String password) async
  {
    User user;
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: mail,
          password: password
      );

      user = userCredential.user;
      return {user : ''};

    } on FirebaseAuthException catch (e)
    {
      if (e.code == 'weak-password')
      {
        return {user : "Password troppo debole"};
      }
      else if (e.code == 'email-already-in-use')
      {
        return {user : "Questo account esiste già!"};
      }
    }

    return {user : 'Qualcosa è andato storto'};
  }

  Future<Map<User, String>> login(String mail, String password) async
  {
    User user;
    try
    {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: mail,
          password: password
      );

      user = userCredential.user;
      return {user : ""};
    } on FirebaseAuthException catch (e)
    {
      if (e.code == 'user-not-found')
      {
        return {user : "Nessun utente corrisponde a questa mail"};
      }
      else if (e.code == 'wrong-password')
      {
        return {user : "Mail o password errati"};
      }
    }

    return {user : "Qualcosa è andato storto"};
  }

  Future<List<Meal>> fetchMeals(String userUID, String date) async
  {
    DataSnapshot snapshot = await _databaseReference.child('$userUID/$date/meals/').once();
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
        double quantity = double.parse(value[key]['quantity'].toString());
        String barcode = value[key]['barcode'].toString();
        print("ENTRATO $quantity");

        Food temp = Food(name:name, kCal: kCal, fats: fats, carbohydrates: carbohydrates,
            proteins: proteins, salt: salt, calcium: calcium, fibers: fibers, imagePath: imagePath,
            barcode: barcode
        );
        temp.setId(key.toString());
        temp.setQuantity(quantity);
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