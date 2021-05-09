import 'package:firebase_database/firebase_database.dart';

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

  List<String> _attributes = List.empty(growable: true);

  List<String> get attributes => List.from(_attributes);

  Food({
    this.name = '', this.kCal = 0, this.fats = 0, this.carbohydrates = 0, this.proteins = 0,
    this.salt = 0, this.calcium = 0, this.fibers = 0, this.imagePath = '',
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

  void setId(String id)
  {
    this._id = id;
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
      'imagePath' : imagePath
    };
  }

  //spostare la logica di arrotondamento in questa classe
}