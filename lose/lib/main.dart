import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lose/pages/HomePage.dart';
import 'package:lose/scoped_models/AppDataModel.dart';
import 'package:scoped_model/scoped_model.dart';


void main()
{
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
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
  final Future<FirebaseApp> _firebaseApp = Firebase.initializeApp(name: 'Lose');

  @override
  void initState()
  {
    super.initState();
  }

  @override
  Widget build(BuildContext context)
  {
    return ScopedModel<AppDataModel>(
      model: AppDataModel(FirebaseApp()),
      child: MaterialApp(
        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch:  Colors.blue,
          accentColor: Colors.blueAccent,
          buttonColor: Colors.lightBlue,
        ),
        routes: {
          '/' : (BuildContext context) => FutureBuilder(
            future: _firebaseApp,
            builder: (BuildContext context, AsyncSnapshot<FirebaseApp> snapshot)
            {
                 if(snapshot.hasError)
                 {
                  print('Errore ${snapshot.error.toString()}');
                  return Text('Qualcosa è andato storto');
                 }
                 else if(snapshot.connectionState == ConnectionState.done)
                 {
                    return HomePage();
                 }

                 return Center(child: CircularProgressIndicator(),);
            }
          ),
        },
      ),
    );
  }
}
