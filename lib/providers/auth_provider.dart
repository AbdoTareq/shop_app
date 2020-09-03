import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
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
    }
    return null;
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
      // idToken came from firebase docs
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      print('dart mess: $_expiryDate');
      _autoLogout();
      notifyListeners();
      // don't forget await
      final prefs = await SharedPreferences.getInstance();
      // store user info as encoded map
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        // to be easily converted to datetime
        'expiryDate': _expiryDate.toIso8601String(),
      });
      prefs.setString('userData', userData);
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

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
  }

  _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final expiryDate = _expiryDate.difference(DateTime.now()).inSeconds;
    Timer(Duration(seconds: expiryDate), logout);
  }
}
