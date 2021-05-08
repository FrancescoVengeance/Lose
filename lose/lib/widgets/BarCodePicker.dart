import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:lose/models/Food.dart';
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
                  if(result != null){
                    setState(() {
                      code = result;
                    });
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
          Text(code),
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
                       });
                      }
                  ),
                  ElevatedButton(
                      child: Text("OK"),
                      onPressed: () {
                        widget._model.addFood(widget._mealIndex, Meal.random.elementAt(Random().nextInt(Meal.random.length -1)));
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

  Future<String> _scanBarcode() async
  {
    return await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 'Cancel', true, ScanMode.BARCODE
    );
  }
}

