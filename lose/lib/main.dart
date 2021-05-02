import 'package:flutter/material.dart';
import 'package:lose/pages/HomePage.dart';
import 'package:lose/scoped_models/AppDataModel.dart';
import 'package:scoped_model/scoped_model.dart';


void main()
{
  runApp(MyApp());
}

class MyApp extends StatefulWidget
{
  @override
  State<StatefulWidget> createState()
  {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp>
{
  @override
  void initState()
  {
    super.initState();
  }

  @override
  Widget build(BuildContext context)
  {
    return ScopedModel<AppDataModel>(
      model: AppDataModel(),
      child: MaterialApp(
        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch:  Colors.blue,
          accentColor: Colors.blueAccent,
          buttonColor: Colors.lightBlue,
        ),
        routes: {
          '/' : (BuildContext context) => HomePage(),
        },
      ),
    );
  }
}
