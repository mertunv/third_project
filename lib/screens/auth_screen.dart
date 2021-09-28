import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../models/http_exception.dart';

enum AuthMode { Signup, Login, Admin }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(48, 213, 200, 1).withOpacity(0.5),
                  Color.fromRGBO(0, 255, 255, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 50.0),
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),
                      transform: Matrix4.rotationZ(0 * pi / 180)
                        ..translate(0.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.cyan.shade600,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        'Z Turizm',
                        style: TextStyle(
                          color: Theme.of(context).accentTextTheme.title.color,
                          fontSize: 50,
                          fontFamily: 'Anton',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();
  var _isAdmin = false;

  void _errorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Hata!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Tamam'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        await Provider.of<Auth>(context, listen: false).login(
          _authData['email'],
          _authData['password'],
        );
      } else if (_authMode == AuthMode.Signup) {
        await Provider.of<Auth>(context, listen: false).signup(
          _authData['email'],
          _authData['password'],
        );
      } else {
        await Provider.of<Auth>(context, listen: false).adminUser(
          _authData['email'],
          _authData['password'],
        );
      }
    } on HttpException catch (error) {
      var errorMessage = 'Dogrulanamadı';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'E-mail adresi kullanılıyor.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'E-mail adresi geçersiz.';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'Şifre zayıf.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'E-mail adresi bulunamadı.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Şifre geçersiz.';
      }
      _errorDialog(errorMessage);
    } catch (error) {
      const errorMessage = 'Doğrulanamadı lütfen tekrar deneyin.';
      _errorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Container(
        height: _authMode == AuthMode.Signup ? 350 : 290,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 260),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  style: TextStyle(
                    fontFamily: 'roboto',
                  ),
                  decoration: InputDecoration(
                    labelText: 'E-Mail',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(300),
                    ),
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  // onChanged: (value) {
                  //   if (value == 'admin@ztourism.com') {
                  //     _isAdmin = true;
                  //   } else {
                  //     _isAdmin = false;
                  //   }
                  // },
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'Geçersiz email!';
                    }
                    return null;
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value;
                  },
                ),
                Divider(),
                TextFormField(
                  style: TextStyle(
                    fontFamily: 'roboto',
                  ),
                  decoration: InputDecoration(
                    labelText: 'Şifre',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(300),
                    ),
                    prefixIcon: Icon(Icons.password_outlined),
                  ),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value.isEmpty || value.length < 5) {
                      return 'Şifre kısa!';
                    }
                  },
                  onSaved: (value) {
                    _authData['password'] = value;
                  },
                ),
                Divider(),
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    style: TextStyle(
                      fontFamily: 'roboto',
                    ),
                    enabled: _authMode == AuthMode.Signup,
                    decoration: InputDecoration(
                      labelText: 'Şifreyi Onayla',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(300),
                      ),
                      prefixIcon: Icon(Icons.password_outlined),
                    ),
                    obscureText: true,
                    validator: _authMode == AuthMode.Signup
                        ? (value) {
                            if (value != _passwordController.text) {
                              return 'Şifre aynı degil!';
                            }
                          }
                        : null,
                  ),
                SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  RaisedButton(
                    child: Text(
                      _authMode == AuthMode.Login ? 'GİRİŞ' : 'HESAP AÇ',
                      style: TextStyle(
                        fontFamily: 'roboto',
                      ),
                    ),
                    onPressed: _submit,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).primaryTextTheme.button.color,
                  ),
                FlatButton(
                  child: Text(
                    '${_authMode == AuthMode.Login ? 'HESAP AÇ' : 'GİRİŞ YAP'}',
                    style: TextStyle(
                      fontFamily: 'roboto',
                    ),
                  ),
                  // '${_authMode == AuthMode.Login ? 'HESAP AC' : 'GIRIS YAP'} INSTEAD'),
                  onPressed: _switchAuthMode,
                  padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textColor: Theme.of(context).primaryColor,
                ),
                // _authMode == AuthMode.Signup
                //     ? Divider()
                //     : Column(
                //         children: <Widget>[
                //           RaisedButton(
                //             onPressed: _submit,
                //             child: Text('Admin Girişi'),
                //             color: Theme.of(context).primaryColor,
                //             textColor:
                //                 Theme.of(context).primaryTextTheme.button.color,
                //             shape: RoundedRectangleBorder(
                //               borderRadius: BorderRadius.circular(30),
                //             ),
                //           ),
                //         ],
                //       ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
