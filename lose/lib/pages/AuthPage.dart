import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lose/models/User.dart';
import 'package:lose/scoped_models/AppDataModel.dart';
import 'package:scoped_model/scoped_model.dart';

class AuthPage extends StatefulWidget
{
  @override
  State<StatefulWidget> createState()
  {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage>
{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordTextController = TextEditingController();
  Map<String, String> _formData = {
    'email' : null,
    'password' : null
  };

  @override
  void initState()
  {
    super.initState();
  }

  @override
  Widget build(BuildContext context)
  {
    return ScopedModelDescendant<AppDataModel>(
        builder: (BuildContext context, Widget widget, AppDataModel model)
        {
          return Scaffold(
            appBar: AppBar(title: Text('Login'),),
            body: Center(
              child: SingleChildScrollView(
                child: Container(
                  width: 300,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        _emailTextField(),
                        SizedBox(height: 10,),
                        _passwordTextField(),
                        SizedBox(height: 20.0),
                        ScopedModelDescendant<AppDataModel>(
                            builder: (BuildContext context, Widget child, AppDataModel model)
                            {
                              return MaterialButton(
                                color: Theme.of(context).accentColor,
                                textColor: Colors.white,
                                child: Text('Login'),
                                onPressed: () =>_submitForm(model),
                              );
                            }
                        ),
                      ],
                    ),
                  ),
                )
              ),
            )
          );
        }
    );
  }

  Widget _emailTextField()
  {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'E-mail',
        filled: true,
        fillColor: Colors.white,
      ),
      keyboardType: TextInputType.emailAddress,
      onSaved: (String value) {
        _formData['email'] = value;
      },
      validator: (String value){
        if(value.isEmpty || !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?").hasMatch(value))
        {
          return 'Questo non è un indirizzo email valido';
        }
        return null;
      },
    );
  }

  Widget _passwordTextField()
  {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Password',
        filled: true,
        fillColor: Colors.white,
      ),
      obscureText: true,
      controller: _passwordTextController,
      onSaved: (String value) {
        _formData['password'] = value;
      },
      validator: (String value) {
        if(value.isEmpty || value.length < 6)
        {
          return 'Password non valida (min 6 caratteri)';
        }
        return null;
      },
    );
  }

  void _submitForm(AppDataModel model) async
  {
    if(_formKey.currentState.validate())
    {
      _formKey.currentState.save();
      print("email: ${_formData['email']}");
      print("password ${_formData['password']}");
      bool success = await model.authenticate(_formData['email'], _formData['password']);
      print(success);
      if(!success)
      {
        showDialog(
            context: context,
            builder: (BuildContext context){
              return AlertDialog(
                title: Text('Qualcosa non va'),
                content: Text('Email o password errati'),
                actions: <Widget>[
                  ElevatedButton(
                    child: Text('OK'),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              );
            }
        );
      }
    }
  }
}

/*

ElevatedButton(
                child: Text('Login'),
                onPressed: () {
                  model.authenticate(User(username: 'Ciccio', mail: 'sps@uni.it'));
                  _authenticate(false);
                },
              ),
 */