import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product extends ChangeNotifier {
  String id;
  String title;
  String description;
  double price;
  String imageUrl;
  bool isFavourite;

  Product({
    required this.title,
    required this.description,
    required this.id,
    required this.price,
    required this.imageUrl,
    this.isFavourite = false,
  });
  void _setFavValue(bool newValue) {
    isFavourite = newValue;
    notifyListeners();
  }

  Future<void> toggleIsFavouriteStatus(token, userId) async {
    final Uri productUrl = Uri.parse(
        'https://flutter-shop-app-96c3a-default-rtdb.europe-west1.firebasedatabase.app/userFavorites/$userId/$id.json?auth=$token');
    final oldStatus = isFavourite;
    isFavourite = !isFavourite;

    notifyListeners();
    try {
      await http.put(
        productUrl,
        body: json.encode(
          {
            'isFavourite': isFavourite,
          },
        ),
      );
    } catch (error) {
      isFavourite = oldStatus;
      notifyListeners();
    }
  }

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final oldStatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    final Uri productUrl = Uri.parse(
        'https://flutter-shop-app-96c3a-default-rtdb.europe-west1.firebasedatabase.app/userFavorites/$userId/$id.json?auth=$token');

    try {
      final response = await http.put(
        productUrl,
        body: json.encode(
          isFavourite,
        ),
      );
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }
}
