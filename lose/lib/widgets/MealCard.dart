import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lose/models/Food.dart';
import 'package:lose/models/Meal.dart';
import 'package:lose/scoped_models/AppDataModel.dart';
import 'package:scoped_model/scoped_model.dart';

class MealCard extends StatelessWidget
{
  Meal _meal;
  final int _mealIndex;

  MealCard(this._meal, this._mealIndex);

  @override
  Widget build(BuildContext context)
  {
    return ScopedModelDescendant<AppDataModel>(
        builder: (BuildContext context, Widget child, AppDataModel model)
        {
          return Card(
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
                _buildActionButtons(model),
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
              return _MealListTile(_meal.foods.elementAt(index), _mealIndex);
            },
            separatorBuilder: (BuildContext context, int index) => Divider(),
        );
  }

  Widget _buildActionButtons(AppDataModel model)
  {
    double totalkCal = 0;
    double totalFats = 0;

    for(Food food in _meal.foods)
    {
      totalkCal += food.kCal;
      totalFats += food.fats;
    }

    return  Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.only(bottom: 3),
          child: Column(
            children: [
              Text('Calorie totali: $totalkCal kCal'),
              Text('Grassi totali: $totalFats g'),
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
                    Food value = Food(name: 'Pisello', fats: 0, kCal: 1000.5, imagePath: 'https://shop.rossolimone.com/1432-large_default/dildo-con-ventosa-5-romeo.jpg');
                    model.addFood(_mealIndex, value);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.read_more_rounded),
                  onPressed: () {
                    //TODO
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

class _MealListTile extends StatelessWidget
{
  Food _food;
  final int _mealIndex;
  int quantity = 100;

  _MealListTile(this._food, this._mealIndex);

  @override
  Widget build(BuildContext context)
  {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(_food.imagePath),
      ),
      title: Text(_food.name),
      subtitle: Text('$quantity g'),
      trailing: _buildDeleteButton(),
      onTap: () {

      },
    );
  }

  Widget _buildDeleteButton()
  {
    return ScopedModelDescendant<AppDataModel>(
        builder: (BuildContext context, Widget widget, AppDataModel model)
        {
          return IconButton (
                  icon: Icon(Icons.remove_circle_outline_rounded),
                  onPressed: () => model.removeFood(_mealIndex, _food)
                );
        }
    );
  }
}