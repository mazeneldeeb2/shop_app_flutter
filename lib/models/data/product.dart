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

  Future<void> toggleIsFavouriteStatus() async {
    final Uri productUrl = Uri.parse(
        'https://flutter-shop-app-96c3a-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json');
    final oldStatus = isFavourite;
    isFavourite = !isFavourite;

    notifyListeners();
    try {
      await http.patch(
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
}
