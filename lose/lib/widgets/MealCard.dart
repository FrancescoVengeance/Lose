import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MealCard extends StatelessWidget
{
  final Function deleteCard;

  MealCard(this.deleteCard);

  @override
  Widget build(BuildContext context)
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
                Text('Pranzo',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 2,
            itemBuilder: (BuildContext context, int index)
            {
              return _MealListTile();
            },
            separatorBuilder: (BuildContext context, int index) => Divider(),
          ),
          Divider(thickness: 2,),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildActionButtons()
  {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 8, bottom: 3),
          child: Column(
            children: [
              Text('Calorie totali: 1200kCal'),
              Text('Grassi totali: 50g'),
              Text('Acqua: 3l')
            ],
          ),
        ),
        SizedBox(width: 5,),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            ButtonBar(
              children: [
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    //TODO
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
                  onPressed: () {
                    deleteCard(this);
                  },
                ),
              ],
            )
          ],
        ),
      ],
    );
  }
}

class _MealListTile extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage('https://www.agireora.org/img/news/pollo-bianco-primo-piano.jpg'),
      ),
      title: Text('Pollo'),
      subtitle: Text('100g'),
      trailing: _buildDeleteButton(),
      onTap: () {

      },
    );
  }

  Widget _buildDeleteButton()
  {
    return IconButton(
        icon: Icon(Icons.remove_circle_outline_rounded),
        onPressed: () {
          //TODO
        }
    );
  }
}