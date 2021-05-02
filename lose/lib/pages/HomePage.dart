
import 'package:flutter/material.dart';
import 'package:lose/widgets/MealCard.dart';

class HomePage extends StatefulWidget
{
  List<MealCard> cards = List.empty(growable: true);

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
    widget.cards.add(MealCard(deleteCard));
    super.initState();
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      drawer: _buildSideDrawer(context),
      appBar: AppBar(title: Text('Lose'),),
      body: ListView.separated(
        padding: EdgeInsets.all(8),
        itemCount: widget.cards.length,
        itemBuilder: (BuildContext context, int index) 
          {
            if(widget.cards.isEmpty)
            {
              return Center(child: Text('Niente da visualizzare'),);  
            }
            return widget.cards.elementAt(index);
          },
        separatorBuilder: (BuildContext context, int index) => Divider(),
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          setState(() {
            widget.cards.add(MealCard(deleteCard));
          });
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

  void deleteCard(MealCard card)
  {
    setState(() {
      widget.cards.remove(card);
    });
  }
}