import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lose/models/Food.dart';
import 'package:lose/models/Meal.dart';
import 'package:lose/scoped_models/AppDataModel.dart';
import 'package:lose/widgets/MealListTile.dart';
import 'package:scoped_model/scoped_model.dart';

class DetailsPage extends StatelessWidget
{
  final Meal _meal;
  final int _mealIndex;
  String _date;

  DetailsPage(this._meal, this._mealIndex, this._date);


  @override
  Widget build(BuildContext context)
  {
    return ScopedModelDescendant<AppDataModel>(
      builder: (BuildContext context, Widget child, AppDataModel model)
        {
          return Scaffold(
            appBar: AppBar(
              title: Text('Dettagli ${_meal.mealType}'),
            ),
            body: ListView(
              children: [
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  separatorBuilder: (BuildContext context, int index) => Divider(),
                  itemCount: _meal.foods.length,
                  itemBuilder: (BuildContext context, int index)
                  {
                    return MealListTile(_meal.foods.elementAt(index), _mealIndex, _date);
                  },
                ),
                Divider(thickness: 2,color: Theme.of(context).accentColor,),
                _buildRecap(),
              ]
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                model.addFood(_mealIndex, Meal.random.elementAt(Random().nextInt(Meal.random.length -1)));
              },
            ),
          );
        }
    );
  }

  Widget _buildRecap()
  {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 10),
          padding: EdgeInsets.all(10),
          //decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          child: Center(
            child: Column(
              children: [
                Text('Calorie totali: ${_meal.totals[Attributes.KCal]} kCal'),
                Text('Grassi totali: ${_meal.totals[Attributes.Fats]} g'),
                Text('Carboidrati totali: ${_meal.totals[Attributes.Carbohydrates]} g'),
                Text('Proteine totali: ${_meal.totals[Attributes.Proteins]} g'),
                Text('Sale totale: ${_meal.totals[Attributes.Salt]} g'),
                Text('Fibre totali: ${_meal.totals[Attributes.Fibers]} g'),
              ],
            ),
          ),
        )
      ],
    );
  }
}