import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';

class AuthProvider with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  bool isAuth() => _token != null ? true : false;

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    } else {
      return null;
    }
  }

  String get userId => _userId ?? 'no userId';

  Future<void> _authenticate(String mail, String pass, urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyAUb5ff9zKxzTV0FhOBN2Mn3IV6BKxqhxs';
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': mail,
            'password': pass,
            'returnSecureToken': true,
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      print('dart mess: $_expiryDate');
      _autoLogout();
      notifyListeners();
    } catch (e) {
      print('dart mess: $e');
      throw e;
    }
  }

  Future<void> signup(String mail, String pass) async {
    return _authenticate(mail, pass, 'signUp');
  }

  Future<void> login(String mail, String pass) async {
    return _authenticate(mail, pass, 'signInWithPassword');
  }

  logout() {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
  }

  _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final expiryDate = _expiryDate.difference(DateTime.now()).inSeconds;
    Timer(Duration(seconds: expiryDate), logout);
  }
}
