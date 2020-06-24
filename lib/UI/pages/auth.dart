import 'package:fashionstore/UI/widgets/ui_elements/adaptive_progress_indicator.dart';
import 'package:fashionstore/core/models/Auth.dart';
import 'package:fashionstore/core/scoped_models/main.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final Map<String, dynamic> _user = {
    'email': null,
    'password': null,
    'type': 0
  };
  final TextEditingController _passCtrl = TextEditingController();
  AnimationController _ctrl;
  Animation<Offset> _slideAnimation;

  AuthMode _authMode = AuthMode.Login;
 

  @override
  initState() {
    super.initState();
    _ctrl =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _slideAnimation = Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.fastOutSlowIn));
  }


  Widget _CompanyName() {
    return   Container(
      height: 220.0,
      width: 110.0,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('images/monkey.gif'),
            fit: BoxFit.fitHeight),
        borderRadius: BorderRadius.only
          (
            bottomLeft: Radius.circular(500.0),
            bottomRight: Radius.circular(500.0)
        ),
      ),
    );
  }

  Widget _buildEmailTextField() {
    return ListTile(
        title: TextFormField(
            onSaved: (String value) => _user['email'] = value,
            validator: (String value) {
              if (value.trim().isEmpty) {
                return 'E-mail cannot be empty';
              } else if (!RegExp(
                      r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                  .hasMatch(value)) {
                return 'Invalid e-mail';
              }
            },
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white70,
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
                labelText: 'E-mail')));
  }

  Widget _buildPassTextField() {
    return ListTile(
        title: TextFormField(
            controller: _passCtrl,
            onSaved: (String value) => _user['password'] = value,
            validator: (String value) {
              if (value.trim().isEmpty) {
                return 'The password cannot be empty';
              } else if (value.trim().length < 6) {
                return 'The password must contain at least 6 characters';
              }
            },
            obscureText: true,
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white70,
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
                labelText: 'Password')));
  }

  Widget _buildPassConfirmTextField() {
    return FadeTransition(
      opacity: CurvedAnimation(parent: _ctrl, curve: Curves.easeIn),
      child: SlideTransition(
        position: _slideAnimation,
        child: ListTile(
            title: TextFormField(
                validator: (String value) {
                  if (_passCtrl.text != value && _authMode == AuthMode.Signup) {
                    return 'Passwords must match';
                  }
                },
                obscureText: true,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white70,
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                    labelText: 'Confirm password'))),
      ),
    );
  }

  Widget _buildDropDwonTextField() {
    return FadeTransition(
      opacity: CurvedAnimation(parent: _ctrl, curve: Curves.easeIn),
      child: SlideTransition(
        position: _slideAnimation,
        child: ListTile(
            title: DropdownButtonFormField(
                onSaved: (var value) {
                  _user['type'] = value;
                },
                items: <String>['Merchant', 'Client']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value == "Merchant" ? '1' : '0',
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (var value) {
                  print(value);
                },
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white70,
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                    labelText: 'Choose Type'))),
      ),
    );
  }

  void _submitForm(Function authenticate, MainModel model) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Map<dynamic, dynamic> authInfo = await authenticate(
          _user['email'],
          _user['password'],
          _authMode,
          _user['type'] == null ? 0 : int.parse(_user['type']));
      if (authInfo['success']) {
         SharedPreferences user = await model.getDataPreferences();
        // print(user.getBool('isAuthenticated'));
        if (user.getBool('isAuthenticated')) {
          Navigator.pushReplacementNamed(context, '/');
        }
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: Text('An Error Occured.'),
                  content: Text(authInfo['message']),
                  actions: <Widget>[
                    FlatButton(
                        child: Text('OK'),
                        onPressed: () => Navigator.of(context).pop())
                  ]);
            });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
//            decoration: BoxDecoration(image: _buildBackgroundImage()),
            child: Center(
                child: SingleChildScrollView(
                    child: Form(
                        key: _formKey,
                        child: Column(children: <Widget>[
                          _CompanyName(),
                          _buildEmailTextField(),
                          _buildPassTextField(),
                          _buildPassConfirmTextField(),
                          _buildDropDwonTextField(),

                          ListTile(title: ScopedModelDescendant<MainModel>(
                              builder: (BuildContext context, Widget child,
                                  MainModel model) {
                            return model.isLoading
                                ? Center(child: AdaptiveProgressIndicator())
                                : RaisedButton(
                                    onPressed: () =>
                                        _submitForm(model.authenticate,model),
                                    child: Text(_authMode == AuthMode.Login
                                        ? 'LOGIN'
                                        : 'SIGN UP'),shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.black),
                            ),
                                    textColor: Colors.white);
                          })),

                          ListTile(
                              title: RaisedButton(
                                  onPressed: () {
                                    if (_authMode == AuthMode.Login) {
                                      setState(() {
                                        _authMode = AuthMode.Signup;
                                      });
                                      _ctrl.forward();
                                    } else {
                                      setState(() {
                                        _authMode = AuthMode.Login;
                                      });
                                      _ctrl.reverse();
                                    }
                                  },
                                  color: Colors.white,
                                  textColor: Theme.of(context).accentColor,
                                  child: Text(
                                      'Switch to ${_authMode == AuthMode.Login ? 'Signup' : 'Login'}'),shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.black),
                              ))),
                        ]))))));
  }
}
