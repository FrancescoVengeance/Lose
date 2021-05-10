
import 'package:flutter/material.dart';
import 'package:lose/models/Food.dart';
import 'package:lose/scoped_models/AppDataModel.dart';
import 'package:scoped_model/scoped_model.dart';

class MealListTile extends StatelessWidget
{
  Food _food;
  final int _mealIndex;
  String _date;

  MealListTile(this._food, this._mealIndex, this._date);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(_food.imagePath),
      ),
      title: Text(_food.name),
      subtitle: Text('${_food.quantity} g'),
      trailing: _buildDeleteButton(),
      onTap: () {
        //TODO
        //aprire la pagina dei dettagli del cibo selezionato
      },
    );
  }

  Widget _buildDeleteButton() {
    return ScopedModelDescendant<AppDataModel>(
        builder: (BuildContext context, Widget widget, AppDataModel model) {
          return IconButton(
              icon: Icon(Icons.remove_circle_outline_rounded),
              onPressed: () => model.removeFood(_mealIndex, _food, _date)
          );
        }
    );
  }
}