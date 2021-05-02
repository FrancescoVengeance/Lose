
import 'package:flutter/material.dart';
import 'package:lose/widgets/MealCard.dart';

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
    return Scaffold(
      drawer: _buildSideDrawer(context),
      appBar: AppBar(title: Text('Lose'),),
      body: ListView.builder(
          itemBuilder: (BuildContext context, int index)
          {
            return MealCard();
          },
          itemCount: 5,
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          //TODO
        },
      ),
    );
  }

  Widget _buildSideDrawer(BuildContext context)
  {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text('UserNickname'),
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