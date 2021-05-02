import 'package:flutter/material.dart';
import 'package:lose/pages/HomePage.dart';


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
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch:  Colors.blue,
        accentColor: Colors.blueAccent,
        buttonColor: Colors.lightBlue,
      ),
      routes: {
        '/' : (BuildContext context) => HomePage(),
      },
    );
  }
}
