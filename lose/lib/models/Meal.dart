import 'package:lose/models/Food.dart';

class Meal
{
  String _mealType;
  List<Food> _foods = List.empty(growable: true);

  Meal(this._mealType)
  {
    //only for debug
    //Food value = Food(name: 'Pollo', fats: 3, kCal: 200.5, imagePath: 'https://www.agireora.org/img/news/pollo-bianco-primo-piano.jpg');
    //_foods.add(value);
    //value = Food(name: 'Tacchino', fats: 10, kCal: 250.5, imagePath: 'https://scenarieconomici.it/wp-content/uploads/2020/02/cute-turkey-bird-cartoon-holding-cutlery_70172-442.jpg');
    //_foods.add(value);
    //value = Food(name: 'Pisello', fats: 0, kCal: 1000.5, imagePath: 'https://shop.rossolimone.com/1432-large_default/dildo-con-ventosa-5-romeo.jpg');
    //_foods.add(value);
  }

  List<Food> get foods => List.from(_foods);

  void addFood(Food food) => _foods.add(food);

  void removeFood(Food food) => _foods.remove(food);

  String get mealType => _mealType;
}