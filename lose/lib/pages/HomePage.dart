
import 'package:flutter/material.dart';

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
      body: Container(child: Center(child: Text('Lose'),),),
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