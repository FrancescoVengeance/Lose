import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:lose/models/DatabaseManager.dart';
import 'package:lose/models/Food.dart';
import 'package:lose/models/FoodDatabaseManager.dart';
import 'package:lose/models/Meal.dart';
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
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
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
                    Text("Per x g", style: TextStyle(fontWeight: FontWeight.bold)),
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
                )
              ],
            ),
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

