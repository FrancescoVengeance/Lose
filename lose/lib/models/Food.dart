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

  Food({
    this.name = '', this.kCal = 0, this.fats = 0, this.carbohydrates = 0, this.proteins = 0,
    this.salt = 0, this.calcium = 0, this.fibers = 0, this.imagePath = '',
  });
}