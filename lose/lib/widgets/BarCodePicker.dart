import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:lose/models/Food.dart';
import 'package:lose/models/FoodDatabaseManager.dart';
import 'package:lose/models/Meal.dart';
import 'package:lose/pages/SearchPage.dart';
import 'package:lose/scoped_models/AppDataModel.dart';

class BarCodePicker extends StatefulWidget
{
  final AppDataModel _model;
  final int _mealIndex;
  BarCodePicker(this._model, this._mealIndex);

  @override
  State<StatefulWidget> createState()
  {
    return _BarCodePickerState();
  }
}

class _BarCodePickerState extends State<BarCodePicker>
{
  String code;
  Food _pickedFood;
  double _weight = 100; //in grammi
  @override
  void initState()
  {
    super.initState();
  }

  @override
  Widget build(BuildContext context)
  {
    double height = MediaQuery.of(context).size.height * (2/3);

    return Container(
      height: code == null ? 120 : height,
      child: Column(
        children: [
          Icon(Icons.arrow_drop_down),
          code == null ? _pickFood() : _showPickedFood(),
        ],
      ),
    );
  }

  Widget _pickFood()
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ButtonBar(
          children: [
            ElevatedButton(
                child: Icon(Icons.camera_alt_outlined),
                onPressed: () async {
                  String result = await _scanBarcode();
                  print("BARCODE $result");
                  if(result != null)
                  {
                    _pickedFood = await FoodDatabaseManager.getInstance().getFoodFromCode(result);
                    if(_pickedFood != null)
                    {
                      setState(() {
                        code = result;
                        //widget._model.addFood(widget._mealIndex, food);
                      });
                    }
                  }
                }
            ),
            ElevatedButton(
                child: Icon(Icons.search_outlined),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => SearchPage()));
                }
            )
          ],
        )
      ],
    );
  }

  Widget _showPickedFood()
  {
    return Container(
      child: Column(
        children: [
          Text("${_pickedFood.name}", style: TextStyle(fontWeight: FontWeight.bold),),
          SizedBox(height: 10,),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text("Per 100g", style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 20,),
                    Text("Energia ${_pickedFood.kCal}"),
                    SizedBox(height: 10,),
                    Text("Grassi ${_pickedFood.fats}"),
                    SizedBox(height: 10,),
                    Text("Carboidrati ${_pickedFood.carbohydrates}"),
                    SizedBox(height: 10,),
                    Text("Proteine ${_pickedFood.proteins}"),
                    SizedBox(height: 10,),
                    Text("Sale ${_pickedFood.salt}"),
                    SizedBox(height: 10,),
                    Text("Calcio ${_pickedFood.calcium}"),
                    SizedBox(height: 10,),
                    Text("Fibre ${_pickedFood.fibers}"),
                  ],
                ),

                Column(
                  children: [
                    Text("Per ${_weight} g", style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 20,),
                    Text("Energia ${Meal.roundDouble((_pickedFood.kCal * _weight) / 100, 2)}"),
                    SizedBox(height: 10,),
                    Text("Grassi ${Meal.roundDouble((_pickedFood.fats * _weight) /100, 2)}"),
                    SizedBox(height: 10,),
                    Text("Carboidrati ${Meal.roundDouble((_pickedFood.carbohydrates * _weight)/100, 2)}"),
                    SizedBox(height: 10,),
                    Text("Proteine ${Meal.roundDouble((_pickedFood.proteins * _weight) /100, 2)}"),
                    SizedBox(height: 10,),
                    Text("Sale ${Meal.roundDouble((_pickedFood.salt * _weight) /100, 2)}"),
                    SizedBox(height: 10,),
                    Text("Calcio ${Meal.roundDouble((_pickedFood.calcium * _weight) /100, 2)}"),
                    SizedBox(height: 10,),
                    Text("Fibre ${Meal.roundDouble((_pickedFood.fibers * _weight) /100 , 2)}"),
                  ],
                )
              ],
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.end,
            children: [
              Text("Quantità"),
              SizedBox(width: 10,),
              IconButton(icon: Icon(Icons.indeterminate_check_box_outlined),
                  onPressed: () {
                    if(_weight > 0)
                    {
                      setState(() {
                        _weight -= 1;
                      });
                    }
                  }
              ),

              SizedBox(width: 10,),
              Text(_weight.toString() + "g"),
              SizedBox(width: 10,),

              IconButton(icon: Icon(Icons.add_box_outlined),
                  onPressed: (){
                    setState(() {
                      _weight += 1;
                    });
                  }
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ButtonBar(
                children: [
                  ElevatedButton(
                      child: Text("Annulla"),
                      onPressed: () {
                       setState(() {
                         code = null;
                         _pickedFood = null;
                       });
                      }
                  ),
                  ElevatedButton(
                      child: Text("OK"),
                      onPressed: () {
                        _pickedFood.setQuantity(_weight);
                        widget._model.addFood(widget._mealIndex, _pickedFood);
                        code = null;
                        _pickedFood = null;
                        Navigator.of(context).pop();
                      }
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<String> _scanBarcode()
  {
    return FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 'Cancel', true, ScanMode.BARCODE
    );
  }
}

