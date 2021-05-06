import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lose/pages/AuthPage.dart';
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
  final Future<FirebaseApp> _firebaseApp = Firebase.initializeApp();
  final AppDataModel model = AppDataModel();

  @override
  void initState()
  {
    model.checkLogin.listen((value) {
      if(value) {setState(() {});}
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context)
  {
    return ScopedModel<AppDataModel>(
      model: model,
      child: MaterialApp(
        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch:  Colors.blue,
          accentColor: Colors.blueAccent,
          buttonColor: Colors.lightBlue,
        ),
        routes: {
          '/' : (BuildContext context)
          {
            return !model.isUserLoggedIn ? AuthPage() : FutureBuilder(
                future: _firebaseApp,
                builder: (BuildContext context, AsyncSnapshot<FirebaseApp> snapshot)
                {
                  if(snapshot.hasError)
                  {
                    print('Errore ${snapshot.error.toString()}');
                    return _networkError();
                  }
                  else if(snapshot.connectionState == ConnectionState.done)
                  {
                    return HomePage();
                  }

                  return Center(child: CircularProgressIndicator(),);
                }
            );
          }
        },
      ),
    );
  }

  Widget _networkError()
  {
    return Scaffold(body: Center(child: Text('Errore di rete. Qualcosa è andato storto'),),);
  }
}
