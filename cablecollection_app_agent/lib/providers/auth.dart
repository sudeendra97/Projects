import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  var _token;
  var _expiryDate;
  var _userId;
  var _authTimer;
  // String url=

  // var baseUrl = 'https://samasthadeeparednet.herokuapp.com/';
  var baseUrl = 'https://demoeazybill.herokuapp.com/';

  bool get isAuth {
    return token != null;
  }

  String get userId {
    return _userId;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<int> authenticate(
    String email,
    String password,
  ) async {
    final url = Uri.parse('${baseUrl}agent/agentsignin');
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          //"Authorization": token,
        },
        body: json.encode(
          {
            'mobile': email,
            'password': password,
          },
        ),
      );
      print(response.statusCode);
      log(response.body);
      final responseData = json.decode(response.body);
      print(responseData);
      print(response.statusCode);

      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['token'];
      _userId = responseData['agent']['uId'];
      _expiryDate = DateTime.now().add(
        Duration(days: 60),
      );
      _autoLogOut();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate.toIso8601String(),
        },
      );
      prefs.setString('userData', userData);
      // print(userData);

      return response.statusCode;

      //  print(json.decode(response.body));
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<void> signUp(var signup) async {
    final url = Uri.parse('${baseUrl}admin/signup');
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          //"Authorization": token,
        },
        body: json.encode(signup),
      );
      final responseData = json.decode(response.body);
      // print(responseData);
      // print(response.statusCode);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['token'];
      _userId = responseData['admin']['uId'];
      _expiryDate = DateTime.now().add(
        Duration(seconds: 172800),
      );
      _autoLogOut();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate.toIso8601String(),
        },
      );
      prefs.setString('userData', userData);
      // print(userData);

      //  print(json.decode(response.body));
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<void> logIn(String email, String password) async {
    return authenticate(
      email,
      password,
    );
  }

  Future<bool> tryAutoLogin() async {
    // logout();
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      print('userData');
      return false;
    }
    final extratedUserData =
        //we should use dynamic as a another value not a Object
        json.decode(prefs.getString('userData')) as Map<String, dynamic>;
    final expiryDate =
        DateTime.parse(extratedUserData['expiryDate'].toString());
    print('auto login $extratedUserData');

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extratedUserData["token"];
    _userId = extratedUserData["userId"];
    _expiryDate = expiryDate;

    notifyListeners();
    _autoLogOut();
    //  print(_token);
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
    prefs.clear();
  }

  void _autoLogOut() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }

    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  // Future<void> signUp(String email, String password) async {
  //   final url = Uri.parse(
  //       'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDHOPk9499CLo2XQHXCbnB6_t2GmXl05Sc');
  //   final response = await http.post(
  //     url,
  //     body: json.encode(
  //       {'email': email, 'password': password, 'returnSecureToken': true},
  //     ),
  //   );
  //   print(json.decode(response.body));
  // }

  // Future<void> logIn(String email, String password) async {
  //   final url = Uri.parse(
  //       'https://identitytoolkit.googleapis.com/v1/accounts:signInWithCustomToken?key=AIzaSyDHOPk9499CLo2XQHXCbnB6_t2GmXl05Sc');
  //   final response = await http.post(
  //     url,
  //     body: json.encode(
  //       {
  //         'email': email,
  //         'password': password,
  //         'returnSecureToken': true,
  //       },
  //     ),
  //   );
  //   print(json.decode(response.body));
  // }
}
