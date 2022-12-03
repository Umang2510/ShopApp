import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';

import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expirydate;
  String _userId;
  Timer _authTimer;

  static const mykey = {
    'key': 'AIzaSyDaGL59OEQ1ZRLHkOK4qFjTkTvzDHZe-pk',
  };

  String get userId {
    return _userId;
  }

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expirydate != null &&
        _expirydate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url = Uri.https('identitytoolkit.googleapis.com', urlSegment, mykey);
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      //print(json.decode(response.body));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expirydate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      _auto_logout();
      notifyListeners();
    } catch (error) {
      return Future.error(error);
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, '/v1/accounts:signUp');
  }

  Future<void> logIn(String email, String password) async {
    return _authenticate(email, password, '/v1/accounts:signInWithPassword');
  }

  void _auto_logout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    } else {}
    final timeToExpiry = _expirydate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  void logout() {
    _token = null;
    _userId = null;
    _expirydate = null;
    if (_authTimer != null) {
      _authTimer.cancel;
    }
    notifyListeners();
  }
}
