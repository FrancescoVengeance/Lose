import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lose/models/Food.dart';
import 'package:lose/models/Meal.dart';
import 'package:lose/pages/DetailsPage.dart';
import 'package:lose/scoped_models/AppDataModel.dart';
import 'package:lose/widgets/MealListTile.dart';
import 'package:scoped_model/scoped_model.dart';

class MealCard extends StatelessWidget
{
  final Meal _meal;
  final int _mealIndex;

  MealCard(this._meal, this._mealIndex);

  @override
  Widget build(BuildContext context)
  {
    return ScopedModelDescendant<AppDataModel>(
        builder: (BuildContext context, Widget child, AppDataModel model)
        {
          return Card(
            elevation: 2,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 3),
                  padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(_meal.mealType, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                    ],
                  ),
                ),
                _buildFoodList(),
                Divider(thickness: 2,),
                _buildActionButtons(model, context),
              ],
            ),
          );
        }
    );
  }

  Widget _buildFoodList()
  {
    return _meal.foods.isEmpty
        ? Container(padding: EdgeInsets.symmetric(vertical: 15),child: Center(child: Text('Aggiungi qualcosa'),))
        : ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _meal.foods.length,
            itemBuilder: (BuildContext context, int index)
            {
              return MealListTile(_meal.foods.elementAt(index), _mealIndex);
            },
            separatorBuilder: (BuildContext context, int index) => Divider(),
        );
  }

  Widget _buildActionButtons(AppDataModel model, BuildContext context)
  {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.only(bottom: 3),
          child: Column(
            children: [
              Text('Totale'),
              Text('Calorie: ${_meal.totals[Attributes.KCal]} kCal'),
              Text('Grassi: ${_meal.totals[Attributes.Fats]} g'),
              Text('Acqua: 3l')
            ],
          ),
        ),
        //SizedBox(width: 5,),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            ButtonBar(
              children: [
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    model.addFood(_mealIndex, Meal.random.elementAt(Random().nextInt(Meal.random.length -1)));
                  },
                ),
                IconButton(
                  icon: Icon(Icons.read_more_rounded),
                  onPressed: () {
                    //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => DetailsPage(_meal, _mealIndex)));
                    model.updateMeal(_meal, _mealIndex);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => model.removeMeal(this._meal)
                ),
              ],
            ),
          ]
        ),
      ],
    );
  }
}