import 'package:flutter/services.dart';
import 'package:lose/models/Food.dart';
import 'package:openfoodfacts/model/NutrientLevels.dart';
import 'package:openfoodfacts/model/parameter/SearchTerms.dart';
import 'package:openfoodfacts/model/parameter/TagFilter.dart';
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

  Future<ProductResult> getProductFromCode(String barcode) async
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

    return res;
  }

  Future<Food> getFoodFromCode(String barcode) async
  {
    ProductResult res = await getProductFromCode(barcode);
    return _buildFood(res.product);
  }

  Food _buildFood(Product product)
  {
    String productName = product.productName;
    double energy = product.nutriments.energyKcal100g;
    double fats = product.nutriments.fat;
    double carbohydrates = product.nutriments.carbohydrates;
    double proteins = product.nutriments.proteins;
    double salt = product.nutriments.salt;
    double calcium = product.nutriments.calcium;
    double fibers = product.nutriments.fiber;
    String imageUrl = product.imageFrontUrl;

    return Food(
        name: productName != null ? productName : "",
        kCal: energy != null ? energy : 0,
        fibers: fibers != null ? fibers : 0,
        calcium: calcium != null ? calcium : 0,
        salt: salt != null ? salt : 0,
        proteins: proteins != null ? proteins : 0,
        carbohydrates: carbohydrates != null ? carbohydrates : 0,
        fats: fats != null ? fats : 0,
        imagePath: imageUrl != null ? imageUrl : "",
        barcode: product.barcode
    );
  }

  Future<List<Food>> searchFood(String keyWords) async
  {
    print("STAI CERCANDO ${keyWords.split(" ")}");
    var parameters = <Parameter>[
      OutputFormat(format: Format.JSON),
      Page(page: 2),
      PageSize(size: 10),
      SearchSimple(active: true),
      SortBy(option: SortOption.PRODUCT_NAME),
      SearchTerms(terms: keyWords.split(" ")),
      TagFilter(tagType: "languages", contains: true, tagName: "italian"),
    ];

    ProductSearchQueryConfiguration configuration = ProductSearchQueryConfiguration(
      parametersList: parameters,
      fields: [ProductField.ALL],
      language: OpenFoodFactsLanguage.ITALIAN,
    );

    try
    {
      SearchResult result = await OpenFoodAPIClient.searchProducts(TestConstants.TEST_USER, configuration);
      List<Food> foods = List.empty(growable: true);
      for(Product p in result.products)
      {
        foods.add(_buildFood(p));
      }
      return foods;
    }
    catch(error)
    {
      print("ERRORE NELLA RICERCA $error");
      return null;
    }
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