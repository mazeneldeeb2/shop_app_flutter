import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/data/errors_exception.dart';

class Auth with ChangeNotifier {
  static const params = {
    'key': 'AIzaSyBeC0dKXtoCu3r4gyrQX0W5Mf3VvDLoDYw',
  };

  String? _token;
  DateTime? _expiryDate;
  late String _userId;
  bool get isAuth {
    if (_token != null &&
        _expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now())) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final authUri = Uri.https(
        'identitytoolkit.googleapis.com', '/v1/accounts:$urlSegment', params);

    try {
      final response = await http.post(
        authUri,
        body: json.encode(
          {
            "email": email,
            "password": password,
            'returnSecureToken': true,
          },
        ),
      );
      var data = json.decode(response.body) as Map<String, dynamic>;

      log(data.toString());
      if (data['error'] != null) {
        log(data['error']['message']);
        throw HttpException(data['error']['message']);
      }
      _token = data['idToken'];
      _userId = data['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            data['expiresIn'],
          ),
        ),
      );
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signup(
    String email,
    String password,
  ) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(
    String email,
    String password,
  ) async {
    return _authenticate(email, password, 'signInWithPassword');
  }
}
