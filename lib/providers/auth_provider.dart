import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  Future<void> signup(String mail, String pass) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyAUb5ff9zKxzTV0FhOBN2Mn3IV6BKxqhxs';
    final response = await http.post(url,
        body: json.encode({
          'email': mail,
          'password': pass,
          'returnSecureToken': true,
        }));
    print('dart mess: ${json.decode(response.body)}');
  }
}
