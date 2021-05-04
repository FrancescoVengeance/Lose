import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lose/models/Food.dart';

class Meal
{
  String _mealType;
  List<Food> _foods = List.empty(growable: true);
  DatabaseReference id;

  void setMealtype(String mealtype)
  {
    this._mealType = mealtype;
  }

  static final List<Food> random = [
    Food(name: 'Pisellone', fats: 10, kCal: 1500, fibers: 10, imagePath: 'https://shop.rossolimone.com/1432-large_default/dildo-con-ventosa-5-romeo.jpg'),
    Food(name: 'Pisellino', fats: 5, kCal: 500, calcium: 0.2, imagePath: 'https://shop.rossolimone.com/1432-large_default/dildo-con-ventosa-5-romeo.jpg'),
    Food(name: 'Piselluccio', fats: 12.2, salt: 1.2, kCal: 1000.5, imagePath: 'https://shop.rossolimone.com/1432-large_default/dildo-con-ventosa-5-romeo.jpg'),
    Food(name: 'Pisellaccio', fats: 20.4, kCal: 1000.5, imagePath: 'https://shop.rossolimone.com/1432-large_default/dildo-con-ventosa-5-romeo.jpg'),
    Food(name: 'Piselletto', fats: 2.33, kCal: 1000.5, carbohydrates: 32, imagePath: 'https://shop.rossolimone.com/1432-large_default/dildo-con-ventosa-5-romeo.jpg'),
    Food(name: 'Pisellotto', fats: 1, kCal: 1000.5, proteins: 30, imagePath: 'https://shop.rossolimone.com/1432-large_default/dildo-con-ventosa-5-romeo.jpg'),
    Food(name: 'Pisellano', fats: 4, kCal: 1000.5, carbohydrates: 90, imagePath: 'https://shop.rossolimone.com/1432-large_default/dildo-con-ventosa-5-romeo.jpg'),
    Food(name: 'Piselluccino', fats: 9.5, kCal: 1000.5, salt: 0.9, imagePath: 'https://shop.rossolimone.com/1432-large_default/dildo-con-ventosa-5-romeo.jpg'),
  ];

  final Map<Attributes, double> totals = {
    Attributes.KCal : 0,
    Attributes.Fats : 0,
    Attributes.Carbohydrates : 0,
    Attributes.Proteins : 0,
    Attributes.Salt : 0,
    Attributes.Calcium : 0,
    Attributes.Fibers : 0,
  };

  Meal(this._mealType)
  {
    //_foods.add(Food(name: 'Pisellone', fats: 10, kCal: 1500, fibers: 10, imagePath: 'https://shop.rossolimone.com/1432-large_default/dildo-con-ventosa-5-romeo.jpg'));
  }

  List<Food> get foods => List.from(_foods);
  String get mealType => _mealType;

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
    totals[Attributes.KCal] = _roundDouble(totals[Attributes.KCal], 2);
    totals[Attributes.Fats] = _roundDouble(totals[Attributes.Fats], 2);
    totals[Attributes.Carbohydrates] = _roundDouble(totals[Attributes.Carbohydrates], 2);
    totals[Attributes.Proteins] = _roundDouble(totals[Attributes.Proteins], 2);
    totals[Attributes.Salt] = _roundDouble(totals[Attributes.Salt], 2);
    totals[Attributes.Fibers] = _roundDouble(totals[Attributes.Fibers], 2);
  }

  double _roundDouble(double value, int places){
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