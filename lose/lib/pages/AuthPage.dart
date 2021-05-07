import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

//TODO
//se elimino l'utente dalla console di firebase e riavvio l'app,
//i dati vengono comunque caricati. Risolvere

class _AuthPageState extends State<AuthPage>
{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordTextController = TextEditingController();
  AuthMode _authMode = AuthMode.Login;
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
              child: model.isLoading ? CircularProgressIndicator() : SingleChildScrollView(
                child: Container(
                  width: 300,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        _emailTextField(),
                        SizedBox(height: 10,),
                        _passwordTextField(),
                        SizedBox(height: 10,),
                        _verifyPassword(),
                        SizedBox(height: 10,),
                        _modeButton(),
                        SizedBox(height: 20.0),
                        ScopedModelDescendant<AppDataModel>(
                            builder: (BuildContext context, Widget child, AppDataModel model)
                            {
                              return MaterialButton(
                                color: Theme.of(context).accentColor,
                                textColor: Colors.white,
                                child: Text(_authMode == AuthMode.Login ? 'Accedi' : 'Registrati'),
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

  Widget _verifyPassword()
  {
    return _authMode == AuthMode.Login ? Container() : TextFormField(
      decoration: InputDecoration(
        labelText: 'Ripeti password',
        filled: true,
        fillColor: Colors.white,
      ),
      obscureText: true,
      validator: (String value) {
        if(_passwordTextController.text != value)
        {
          return 'I campi password non corrispondono';
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

      Map<bool, String> message;
      if(_authMode == AuthMode.Register)
      {
        message = await model.register(_formData['email'], _formData['password']);
        print(message);
      }

      if(_authMode == AuthMode.Login)
      {
        message = await model.login(_formData['email'], _formData['password']);
        print(message);
      }

      if(!message.keys.first)
      {
        showDialog(
            context: context,
            builder: (BuildContext context){
              return AlertDialog(
                title: Text('Qualcosa non va'),
                content: Text(message.values.first),
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

  Widget _modeButton()
  {
    String text = _authMode == AuthMode.Login
        ? "Non registrato? crea un nuovo account"
        : "Già registrato? effettua l'accesso";
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: EdgeInsets.all(10),
          child: GestureDetector(
              child: Text(text, style: TextStyle(color: Theme.of(context).accentColor),),
              onTap: () {
                setState(() {
                  _passwordTextController.clear();
                  if (_authMode == AuthMode.Login)
                  {
                    _authMode = AuthMode.Register;
                  }
                  else
                  {
                    _authMode = AuthMode.Login;
                  }
                });
              }
          ),
        ),
      ],
    );
  }
}

enum AuthMode
{
  Login,
  Register
}