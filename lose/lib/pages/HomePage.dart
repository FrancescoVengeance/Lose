import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lose/models/Meal.dart';
import 'package:lose/scoped_models/AppDataModel.dart';
import 'package:lose/widgets/MealCard.dart';
import 'package:scoped_model/scoped_model.dart';

class HomePage extends StatefulWidget
{
  @override
  State<StatefulWidget> createState()
  {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage>
{
  @override
  void initState()
  {
    super.initState();
  }

  @override
  Widget build(BuildContext context)
  {
    return ScopedModelDescendant<AppDataModel>(
        builder: (BuildContext context, Widget child, AppDataModel model)
        {
          return  Scaffold(
            drawer: _buildSideDrawer(context, model.user.username, model.user.image),
            appBar: AppBar(title: Text('Lose'),),
            body: ListView.separated(
              padding: EdgeInsets.all(8),
              itemCount: model.meals.length,
              itemBuilder: (BuildContext context, int index)
              {
                if(model.meals.isEmpty)
                {
                  return Center(child: Text('Niente da visualizzare'),);
                }
                return MealCard(model.meals.elementAt(index), index);
              },
              separatorBuilder: (BuildContext context, int index) => Divider(),
            ),

            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                Meal meal = Meal("Cena");
                model.addMeal(meal);
              },
            ),
          );
        }
    );
  }

  Widget _buildSideDrawer(BuildContext context, String username, String userImage)
  {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text(username),
            leading: Container(
              margin: EdgeInsets.all(3),
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(userImage),),
            ),
          ),
          ListTile(
            title: Text('Opzioni'),
            trailing: Icon(Icons.settings),
            onTap: () {
              //TODO
            },
          ),
          Divider(),
          ListTile(
            title: Text('Logout'),
            trailing: Icon(Icons.logout),
            onTap: () {
              //TODO
            },
          ),
        ],
      ),
    );
  }

}