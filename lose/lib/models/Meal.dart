import 'dart:math';
import 'package:lose/models/Food.dart';

class Meal
{
  String _mealType;
  List<Food> _foods = List.empty(growable: true);
  String _id;

  final Map<Attributes, double> totals = {
    Attributes.KCal : 0,
    Attributes.Fats : 0,
    Attributes.Carbohydrates : 0,
    Attributes.Proteins : 0,
    Attributes.Salt : 0,
    Attributes.Calcium : 0,
    Attributes.Fibers : 0,
  };

  Meal(this._mealType);

  Meal.noParams();


  List<Food> get foods => List.from(_foods);
  String get mealType => _mealType;
  String get id => _id;

  void setMealtype(String mealtype)
  {
    this._mealType = mealtype;
  }

  void setId(String id)
  {
    _id = 'meals/$id';
  }

  void addFood(Food food)
  {
    _foods.add(food);

    totals[Attributes.KCal] += food.kCal;
    totals[Attributes.Fats] += food.fats;
    totals[Attributes.Carbohydrates] += food.carbohydrates;
    totals[Attributes.Proteins] += food.proteins;
    totals[Attributes.Salt] += food.salt;
    totals[Attributes.Fibers] += food.fibers;

    _round();
  }

  void removeFood(Food food)
  {
    _foods.remove(food);

    totals[Attributes.KCal] -= food.kCal;
    totals[Attributes.Fats] -= food.fats;
    totals[Attributes.Carbohydrates] -= food.carbohydrates;
    totals[Attributes.Proteins] -= food.proteins;
    totals[Attributes.Salt] -= food.salt;
    totals[Attributes.Fibers] -= food.fibers;

    _round();
  }

  void _round()
  {
    totals[Attributes.KCal] = roundDouble(totals[Attributes.KCal], 2);
    totals[Attributes.Fats] = roundDouble(totals[Attributes.Fats], 2);
    totals[Attributes.Carbohydrates] = roundDouble(totals[Attributes.Carbohydrates], 2);
    totals[Attributes.Proteins] = roundDouble(totals[Attributes.Proteins], 2);
    totals[Attributes.Salt] = roundDouble(totals[Attributes.Salt], 2);
    totals[Attributes.Fibers] = roundDouble(totals[Attributes.Fibers], 2);
  }

  static double roundDouble(double value, int places){
    double mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  Map<String, dynamic> toJson()
  {
    return {
      'type' : _mealType,
    };
  }
}

enum Attributes
{
  KCal,
  Fats,
  Carbohydrates,
  Proteins,
  Salt,
  Calcium,
  Fibers
}