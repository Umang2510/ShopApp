import 'dart:convert';

import 'package:flutter/widgets.dart';

import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expirydate;
  String _userId;

  static const mykey = {
    'key': 'AIzaSyDaGL59OEQ1ZRLHkOK4qFjTkTvzDHZe-pk',
  };

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
}
