import 'package:lose/models/Food.dart';
import 'package:openfoodfacts/model/NutrientLevels.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

class FoodDatabaseManager
{
  static FoodDatabaseManager _instance;

  FoodDatabaseManager._createInstance();

  static FoodDatabaseManager getInstance()
  {
    if(_instance == null)
    {
      _instance = FoodDatabaseManager._createInstance();
    }
    return _instance;
  }

  Future<Food> getFoodFromCode(String barcode) async
  {
    ProductQueryConfiguration configurations = ProductQueryConfiguration(
        barcode,
        language: OpenFoodFactsLanguage.ITALIAN,
        fields: [ProductField.ALL]
    );

    ProductResult res = await OpenFoodAPIClient.getProduct(configurations, user: TestConstants.TEST_USER);

    if(res.status != 1) {
      print("Error retreiving the product ${res.statusVerbose}");
      return null;
    }

    String productName = res.product.productName;
    double energy = res.product.nutriments.energyKcal100g;
    double fats = res.product.nutriments.fat;
    double carbohydrates = res.product.nutriments.carbohydrates;
    double proteins = res.product.nutriments.proteins;
    double salt = res.product.nutriments.salt;
    double calcium = res.product.nutriments.calcium;
    double fibers = res.product.nutriments.fiber;
    String imageUrl = res.product.imageFrontUrl;

    return Food(
      name: productName != null ? productName : "",
      kCal: energy != null ? energy : 0,
      fibers: fibers != null ? fibers : 0,
      calcium: calcium != null ? calcium : 0,
      salt: salt != null ? salt : 0,
      proteins: proteins != null ? proteins : 0,
      carbohydrates: carbohydrates != null ? carbohydrates : 0,
      fats: fats != null ? fats : 0,
      imagePath: imageUrl != null ? imageUrl : ""
    );
  }
}

class TestConstants {
  /// TODO: insert your user login for OpenFoodFacts here
  static const User TEST_USER = User(
    userId: 'openfoodfacts-dart',
    password: 'iloveflutter',
    comment: 'dart API test',
  );

  static const User PROD_USER = User(
    userId: 'grumpf@gmx.de',
    password: 'takeitorleaveit',
    comment: 'dart API test',
  );
}