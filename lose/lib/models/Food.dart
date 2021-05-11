import 'package:firebase_database/firebase_database.dart';
import 'package:lose/models/Meal.dart';

class Food
{
  //all values are based per 100g
  String name;
  double kCal;
  double fats;
  double carbohydrates;
  double proteins;
  double salt;
  double calcium;
  double fibers;
  String imagePath;
  String _id;
  double _quantity = 100;
  final String barcode;

  List<String> _attributes = List.empty(growable: true);

  List<String> get attributes => List.from(_attributes);

  Food({
    this.name = '', this.kCal = 0, this.fats = 0, this.carbohydrates = 0, this.proteins = 0,
    this.salt = 0, this.calcium = 0, this.fibers = 0, this.imagePath = '', this.barcode
  }){
    _attributes.add("Nome $name");
    _attributes.add("Energia $kCal Kcal");
    _attributes.add("Grassi $fats");
    _attributes.add("Carboidrati $carbohydrates");
    _attributes.add("Proteine $proteins");
    _attributes.add("Sale $salt");
    _attributes.add("Calcio $calcium");
    _attributes.add("Fibre $fibers");
  }

  String get id => _id;
  double get quantity => _quantity;

  void setId(String id)
  {
    this._id = id;
  }

  void setQuantity(double quantity)
  {
    _quantity = quantity;

    kCal = Meal.roundDouble((kCal * _quantity / 100), 2);
    fats = Meal.roundDouble((fats * _quantity / 100), 2);
    carbohydrates = Meal.roundDouble((carbohydrates * _quantity / 100), 2);
    proteins = Meal.roundDouble((proteins * _quantity / 100), 2);
    salt = Meal.roundDouble((salt * _quantity / 100), 2);
    calcium = Meal.roundDouble((calcium * _quantity / 100), 2);
    fibers = Meal.roundDouble((fibers * _quantity / 100), 2);
  }

  Map<String, dynamic> toJson()
  {
    return {
      'name' : name,
      'kCal' : kCal,
      'fats' : fats,
      'carbohydrates' : carbohydrates,
      'proteins' : proteins,
      'salt' : salt,
      'calcium' : calcium,
      'fibers' : fibers,
      'imagePath' : imagePath,
      'quantity' : _quantity,
      'barcode': barcode
    };
  }

  //spostare la logica di arrotondamento in questa classe
}