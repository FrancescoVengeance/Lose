import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lose/models/Food.dart';
import 'package:lose/scoped_models/AppDataModel.dart';
import 'package:lose/widgets/MealListTile.dart';
import 'package:scoped_model/scoped_model.dart';

class SearchPage extends StatefulWidget
{
  @override
  State<StatefulWidget> createState()
  {
    return _SearchPageState();
  }
}

class _SearchPageState extends State<SearchPage>
{
  String _searchedText = "";
  TextEditingController _textController = TextEditingController();
  List<Food> _foods;

  @override
  Widget build(BuildContext context)
  {
    return ScopedModelDescendant<AppDataModel>(
      builder: (BuildContext context, Widget child, AppDataModel model)
      {
        return  Scaffold(
            appBar: AppBar(title: Text("Lose"),),
            body: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      _searchBar(model),
                    ],
                  ),
                ),
                model.isLoading ? Center(child: CircularProgressIndicator()) : Container(),
                _foods == null && model.isLoading ? Container() : Flexible(
                  fit: FlexFit.loose,
                  child: ListView.separated(
                    shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index){
                        return MealListTile(_foods.elementAt(index), null, null);
                      },
                      separatorBuilder: (BuildContext context, int index) => Divider(),
                      itemCount: _foods == null ? 0 : _foods.length
                  ),
                )
              ],
            )
        );
      },
    );
  }

  Widget _searchBar(AppDataModel model)
  {
    return Expanded(
      child: TextFormField(
        controller: _textController,
        autofocus: true,
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: () async
              {
                _searchedText = _textController.value.text.toLowerCase();
                List<Food> prod = await model.searchProduct(_searchedText);
                if(prod != null)
                {
                  setState(() {
                    _foods = prod;
                  });
                }
                print("PRODOTTO ${prod.elementAt(0).name}");
              },
            )
        ),
        validator: (String value) {
          if(value.isEmpty || value == " "){
            return "Inserire delle parole chiave per la ricerca";
          }
          return null;
        },
      ),
    );
  }
}