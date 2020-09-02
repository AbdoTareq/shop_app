import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  Future<void> _authenticate(String mail, String pass, urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyAUb5ff9zKxzTV0FhOBN2Mn3IV6BKxqhxs';
    final response = await http.post(url,
        body: json.encode({
          'email': mail,
          'password': pass,
          'returnSecureToken': true,
        }));
    print('dart mess: ${json.decode(response.body)}');
  }

  Future<void> signup(String mail, String pass) async {
    return _authenticate(mail, pass, 'signUp');
  }

  Future<void> login(String mail, String pass) async {
    return _authenticate(mail, pass, 'signInWithPassword');
  }
}
