import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';
import '../models/http_exception.dart';
import '../providers/ad.dart' as a;

class Auth with ChangeNotifier {
  String _token;
  DateTime _expireDate;
  String _userId;
  Timer _authenticationTimer;
  bool _isAdmin = false;
  String email;
  bool _st = false;
  // bool isAdmin = a.isAd;

  // bool admin(user) {
  //   if (user == 'admin@ztourism.com') {
  //     _isAdmin = true;
  //     return true;
  //   }
  //   _isAdmin = false;
  //   return false;
  // }

  // bool get isAdmin {
  //   print('isAdmin: ' + _isAdmin.toString());
  //   return true;
  // }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    // admin(email);
    if (email == 'admin@ztourism.com') {
      _st = true;
      a.isAd = true;
    } else {
      _st = false;
      a.isAd = false;
    }
    print(_st.toString() + ': st');
    adminSet(_st);
    print(a.isAd.toString() + ': isAdmin');
    // adminGet(_isAdmin);
    // print('isAdmin: ' + _isAdmin.toString());
    // print('user: ' + email.toString());
    return _authenticate(email, password, 'signInWithPassword');
  }

  adminGet() {
    // if (_expireDate != null && _expireDate.isAfter(DateTime.now())) {
    //   _st = state;
    //   print('st: ' + _st.toString());
    // }

    // print('st1: ' + _st.toString());
    // return _st;
    if (_isAdmin) {
      print(_isAdmin.toString() + ': _isAdmin');
      return true;
    } else if (_isAdmin) {
      print(_isAdmin.toString() + ': _isAdminFalse');
      return false;
    }
  }

  adminSet(exp) {
    if (exp == true) {
      _isAdmin = true;
    } else {
      _isAdmin = false;
    }
  }

  bool adminUser(String email, String password) {
    // if (_st == true) {
    //   print('st2: ' + _st.toString());
    //   return true;
    // } else {
    //   print('st3: ' + _st.toString());
    //   return false;
    // }
    _authenticate(email, password, 'signInWithPassword');
    _isAdmin = true;
    adminSet(_isAdmin);
    print(_isAdmin);
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyCsbQVNhVet22g-CheNR2bCs-UmiXOQWxY';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );
      final errorData = json.decode(response.body);
      if (errorData['error'] != null) {
        throw HttpException(errorData['error']['message']);
      }
      _token = errorData['idToken'];
      _userId = errorData['localId'];
      _expireDate = DateTime.now().add(
        Duration(
          seconds: int.parse(errorData['expiresIn']),
        ),
      );
      _autoLogout();
      // if (email == 'admin@ztourism.com') {
      //   _st = true;
      // } else {
      //   _st = false;
      // }
      notifyListeners();
      final preferences = await SharedPreferences.getInstance();
      final userPrefs = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expireDate': _expireDate.toIso8601String(),
        },
      );
      preferences.setString('userPrefs', userPrefs);
    } catch (error) {
      throw error;
    }
  }

  bool get isAuthenticated {
    return token != null;
  }

  String get token {
    if (_expireDate != null &&
        _expireDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expireDate = null;
    if (_authenticationTimer != null) {
      _authenticationTimer.cancel();
      _authenticationTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userPrefs');
  }

  String get userId {
    return _userId;
  }

  void _autoLogout() {
    if (_authenticationTimer != null) {
      _authenticationTimer.cancel();
    }
    final countToExpiration = _expireDate.difference(DateTime.now()).inSeconds;
    _authenticationTimer = Timer(Duration(seconds: countToExpiration), logout);
  }

  Future<bool> tryAutoLog() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userPrefs')) {
      return false;
    }
    final extracUserPref =
        json.decode(prefs.getString('userPrefs')) as Map<String, Object>;
    final expDate = DateTime.parse(extracUserPref['expireDate']);
    if (expDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extracUserPref['token'];
    _userId = extracUserPref['userId'];
    _expireDate = expDate;
    notifyListeners();
    _autoLogout();
    return true;
  }
}
