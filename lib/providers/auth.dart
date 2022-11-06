import 'dart:convert';

import 'package:flutter/widgets.dart';

import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String _token;
  DateTime _expirydate;
  String _userId;

  static const mykey = {
    'key': 'AIzaSyDaGL59OEQ1ZRLHkOK4qFjTkTvzDHZe-pk',
  };

  Future<void> signUp(String email, String password) async {
    final url = Uri.https(
        'identitytoolkit.googleapis.com', '/v1/accounts:signUp', mykey);
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
  }

  Future<void> logIn(String email, String password) async {
    final url = Uri.https(
        'identitytoolkit.googleapis.com', 'accounts:signInWithPassword', mykey);

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
    print(json.decode(response.body));
  }
}
