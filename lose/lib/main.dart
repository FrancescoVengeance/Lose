import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lose/pages/AuthPage.dart';
import 'package:lose/pages/HomePage.dart';
import 'package:lose/scoped_models/AppDataModel.dart';
import 'package:scoped_model/scoped_model.dart';


void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  DateTime now = DateTime.now();
  //print(DateTime(now.year, now.month, now.day));

  //await FirebaseAuth.instance.signOut();
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
  //final Future<FirebaseApp> _firebaseApp = Firebase.initializeApp();
  final AppDataModel model = AppDataModel();
  bool _isLogged = true;

  @override
  void initState()
  {
    FirebaseAuth.instance.authStateChanges().listen((User user) async {

      if(user == null)
      {
        setState(() {
          _isLogged = false;
        });
      }
      else
      {
        //await model.autologin();
        setState(() {
          print('User logged');
          _isLogged = true;
        });
      }
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
            return _isLogged ? HomePage() : AuthPage(); /*FutureBuilder(
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
                }*/
            //);
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
