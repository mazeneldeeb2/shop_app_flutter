import 'package:flutter/foundation.dart';

class Product extends ChangeNotifier {
  int id;
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

  void toggleIsFavouriteStatus() {
    isFavourite = !isFavourite;
    notifyListeners();
  }
}
