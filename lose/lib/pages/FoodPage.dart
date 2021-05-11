import 'package:flutter/material.dart';
import 'package:lose/models/Food.dart';
import 'package:lose/scoped_models/AppDataModel.dart';
import 'package:openfoodfacts/model/Ingredient.dart';
import 'package:openfoodfacts/model/ProductResult.dart';
import 'package:scoped_model/scoped_model.dart';

class FoodPage extends StatelessWidget
{
  final Food _food;
  ProductResult _res;
  AppDataModel _model;
  List<Text> _statsPer100g = List.empty(growable: true);

  FoodPage(this._food, this._model)
  {
    _getRes();
  }

  @override
  Widget build(BuildContext context)
  {
    return ScopedModelDescendant<AppDataModel>(
        builder: (BuildContext context, Widget child, AppDataModel model)
        {
          return Scaffold(
            appBar: AppBar(title: Text("Dettagli ${_food.name}"),),
            body: model.isLoading
                ? Center(child: CircularProgressIndicator(),)
                : SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.all(10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_food.name, style: TextStyle(fontWeight: FontWeight.bold),),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          //decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image(image: NetworkImage(_food.imagePath), height: 200, width: 150,),
                              _showStats(),
                            ],
                          ),
                        ),
                        Center(child: Text("Per 100g", style: TextStyle(fontWeight: FontWeight.bold)),),
                        _showStatsPer100g(),
                      ],
                    ),
                ),
              )
          );
        }
    );
  }

  Widget _showStats()
  {
    return Container(
      //decoration: BoxDecoration(border: Border.all(color: Colors.red)),
      padding: EdgeInsets.only(left: 10),
      child: Column(
        children: <Widget>[
          Text("Per ${_food.quantity}g",style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 10,),
          Text("Energia ${_food.kCal} KCal"),
          SizedBox(height: 10,),
          Text("Grassi ${_food.fats}g"),
          SizedBox(height: 10,),
          Text("Carboidrati ${_food.carbohydrates}g"),
          SizedBox(height: 10,),
          Text("Proteine ${_food.proteins}g"),
          SizedBox(height: 10,),
          Text("Sale ${_food.salt}g"),
          SizedBox(height: 10,),
          Text("Calcio ${_food.calcium}g"),
          SizedBox(height: 10,),
          Text("Fibre ${_food.fibers}g"),
        ],
      ),
    );
  }

  Widget _showStatsPer100g()
  {
    return Flexible(
      fit: FlexFit.loose,
      child: Container(
          margin: EdgeInsets.only(top: 20),
          child: ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _statsPer100g.length,
            itemBuilder: (BuildContext context, int index)
            {
              return _statsPer100g.elementAt(index);
            },
            separatorBuilder: (BuildContext context, int index) => Divider(),
          )
      ),
    );
  }

  void _getRes() async
  {
    _res = await _model.getProductFromCode(_food.barcode);

    _statsPer100g.add(Text("Energia ${_res.product.nutriments.energyKcal100g} KCal"));
    _statsPer100g.add(Text("Grassi ${_res.product.nutriments.fat}g"));
    _statsPer100g.add(Text("Carboidrati ${_res.product.nutriments.carbohydrates}g"));
    _statsPer100g.add(Text("Proteine ${_res.product.nutriments.proteins}g"));
    _statsPer100g.add(Text("Sale ${_res.product.nutriments.salt}g"));
    _statsPer100g.add(Text("Calcio ${_res.product.nutriments.calcium}g"));
    _statsPer100g.add(Text("Fibre ${_res.product.nutriments.fiber}g"));

    for(Ingredient i in _res.product.ingredients)
    {
      print("Ingrediente" + i.text);
    }
  }
}