import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/models/http_exception.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_ecommerce/utils/preferences.dart';

PreferenceUtil appData = PreferenceUtil();

class Auth with ChangeNotifier {

  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  bool get isAuth {
    return _token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }

    return null;
  }

  String get userId {
    return _userId;
  }

  /*Future<void> _authenticate(String email, String password, String url) async {
    try {
      final response = await http.post(url,
          body: json.encode({
            "email": email,
            "password": password,
            "returnSecureToken": true,
          }));

      final responseData = json.decode(response.body);
      if (responseData["error"] != null) {
        throw HttpException(responseData["error"]["message"]);
      }

      _token = responseData["idToken"];
      _userId = responseData["localId"];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData["expiresIn"])));

      _autoLogout();
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
          {"token": _token, "userId": _userId, "expiryDate": DateTime.now().toIso8601String});
      prefs.setString("userData", userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp(String email, String password) async {
    const url =
        "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=${'AIzaSyD42-MPdWKS-pgb3EgWuuEE6wQnKPEN69g'}";

    return _authenticate(email, password, url);
  }

  Future<void> login(String email, String password) async {
    const url =
        "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=${'AIzaSyD42-MPdWKS-pgb3EgWuuEE6wQnKPEN69g'}";

    return _authenticate(email, password, url);
  }*/

  Future<void> signUp(String email, String password) async {
    const urlSegment = "accounts:signUp";

    return _authenticate(email, password, urlSegment);
  }

  Future<void> login(String email, String password) async {
    const urlSegment = "accounts:signInWithPassword";

    return _authenticate(email, password, urlSegment);
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/$urlSegment?key=${'AIzaSyD42-MPdWKS-pgb3EgWuuEE6wQnKPEN69g'}';
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
      // mengambil response
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      // response dari firebase auth
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      // ketika user baru signup
      if (urlSegment == 'accounts:signUp') {
        // create user ketika baru mendaftar
        await Firestore.instance.collection("users").document(_userId).setData({
          "user_id": _userId,
          "email": email,
          "password": password,
        }).whenComplete(() {
          // simpan shared prefences
          appData.saveVariable("user_id", _userId);
          appData.saveVariable("email", email);
        });
      } else {
        // simpan shared prefences ketika sudah pernah buat
        await Firestore.instance
            .collection("users")
            .document(_userId)
            .get()
            .then((onValue) {
          appData.saveVariable("user_id", onValue.data['user_id']);
          appData.saveVariable("email", onValue.data['email']);
        });
      }
      _autoLogout();
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
    } catch (error) {
      throw error;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey("userData")) {
      return false;
    }

    final extractedUserData =
        json.decode(prefs.getString("userData")) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData["expiryDate"]);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = extractedUserData["token"];
    _userId = extractedUserData["userId"];
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();

    return true;
  }





  Future logOut() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.remove("userData");
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), () {
      logOut();
    });
  }
}
