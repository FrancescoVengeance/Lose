import 'package:flutter/material.dart';

class MealCard extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return Card(
      child: ListView.builder(
          itemBuilder: (BuildContext context, int index)
          {
              return _buildListTile();
          },
          itemCount: 5,
      ),
    );
  }

  Widget _buildListTile()
  {
    return Column(
      children: <Widget> [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage('https://www.agireora.org/img/news/pollo-bianco-primo-piano.jpg'),
          ),
          title: Text('Pollo'),
          subtitle: Text('100g'),
          trailing: _buildDeleteButton(),
        ),
        Divider(),
      ]
    );
  }

  Widget _buildDeleteButton()
  {
    return IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          //TODO
        }
    );
  }

}