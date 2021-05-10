import 'package:flutter/material.dart';
import 'package:lose/models/DatabaseManager.dart';
import 'package:lose/models/DateFormat.dart';
import 'package:lose/models/Meal.dart';
import 'package:lose/scoped_models/AppDataModel.dart';
import 'package:lose/widgets/MealCard.dart';
import 'package:scoped_model/scoped_model.dart';

class HomePage extends StatefulWidget
{
  DateTime currentDate = DateTime.now();

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
            drawer: !model.isLoading ? _buildSideDrawer(context, model, "https://shop.scavino.it/files/scavino2_Files/Foto/205352_3.PNG") : Container(),
            appBar: AppBar(title: Text('Lose'),),
            body: model.isLoading ? _loading() : Column(
              children: [
                _showDate(model),
                _showMealsList(model),
              ],
            ),

            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () async {
                await _showCreateMealDialog(model);
              },
            ),
          );
        }
    );
  }

  Widget _buildSideDrawer(BuildContext context, AppDataModel model, String userImage)
  {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text(model.user.email.split("@")[0]),
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
            onTap: () async {
              await model.logOut();
            },
          ),
        ],
      ),
    );
  }

  String _nomePasto;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _showCreateMealDialog(AppDataModel model)
  {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context)
        {
          return AlertDialog(
            elevation: 24,
            title: Text('Aggiungi nuovo pasto'),
            content: SingleChildScrollView(
              child: Form(
                  key: _formKey,
                  child: TextFormField(
                      autofocus: true,
                      decoration: InputDecoration(
                        labelText: 'Inserisci nome pasto',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onSaved: (value){
                        _nomePasto = value;
                      }
                  )
              ),
            ),
            actions: <Widget>[
              MaterialButton(
                child: Text('Annulla'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              MaterialButton(
                child: Text('Crea'),
                onPressed: () async {
                  _formKey.currentState.save();
                  if(!model.addMeal(Meal(_nomePasto))) {
                    await _showAlertDialog();
                  }
                  else
                  {
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          );
        }
    );
  }

  Future<void> _showAlertDialog()
  {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 24,
          title: Text('Attenzione'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Non puoi aggiungere nello stesso giorno'),
                Text('due pasti dello stesso tipo'),
                Text('(es. due cene o due pranzi).'),
                Text('Per favore inserisci un nome diverso per ogni pasto')
              ],
            ),
          ),
          actions: <Widget>[
            MaterialButton(
              child: Text('Capito!'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _loading()
  {
    return Center(child: CircularProgressIndicator(),);
  }

  Widget _showDate(AppDataModel model)
  {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: [
        IconButton(
            icon: Icon(Icons.arrow_back_rounded),
            onPressed: () {}
        ),

        SizedBox(width: 20,),
        TextButton(
          child: Text(DateFormat.dateToString(widget.currentDate)),
          onPressed: () async {
            DateTime time = await _selectDate(context);
            if(time != null)
            {
              setState(() {
                widget.currentDate = time;
              });
              await model.fetchMealsDate(DateFormat.dateToString(widget.currentDate));
            }
          },
        ),
        SizedBox(width: 20,),

        IconButton(
          icon: Icon(Icons.arrow_forward_rounded),
          onPressed: () {},
        ),
      ],
    );
  }

  Future<DateTime> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: widget.currentDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != widget.currentDate)
    {
      return pickedDate;
    }
    return null;
  }

  Widget _showMealsList(AppDataModel model)
  {
    return Expanded(
      child: ListView.separated(
        padding: EdgeInsets.all(8),
        itemCount: model.meals.length,
        itemBuilder: (BuildContext context, int index)
        {
          if(model.meals.isEmpty)
          {
            return Center(child: Text('Niente da visualizzare'),);
          }
          return MealCard(model.meals.elementAt(index), index, DateFormat.dateToString(widget.currentDate));
        },
        separatorBuilder: (BuildContext context, int index) => Divider(),
      ),
    );
  }
}