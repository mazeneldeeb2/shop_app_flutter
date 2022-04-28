import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

import '../data/product.dart';

class Products with ChangeNotifier {
  bool _showFavorites = false;
  bool get showFavoritesValue {
    return _showFavorites;
  }

  static const urlString =
      'https://flutter-shop-app-96c3a-default-rtdb.europe-west1.firebasedatabase.app/products.json';

  static final url = Uri.parse(urlString);

  final List<Product> _products = [
    Product(
      id: "a",
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: "v",
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: "c",
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: "d",
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];
  List<Product> _favorites = [];
  List<Product> get favourites {
    return [..._favorites];
  }

  List<Product> get products {
    // if (_showFavorites) {
    //   return _products.where((product) => product.isFavourite).toList();
    // }
    return [..._products];
  }

  void refreshProductsList() {
    notifyListeners();
  }

  void showFavorites() {
    _favorites = _products.where((product) => product.isFavourite).toList();
    _showFavorites = true;
    notifyListeners();
  }

  void showAll() {
    _showFavorites = false;
    notifyListeners();
  }

  Product findProductById(String id) {
    return _products.firstWhere((product) => product.id == id);
  }

  void addProduct(Product newProduct) {
    http
        .post(
      url,
      body: json.encode(
        {
          'title': newProduct.title,
          'description': newProduct.description,
          'imageUrl': newProduct.imageUrl,
          'price': newProduct.price,
          'isFavourite': newProduct.isFavourite,
        },
      ),
    )
        .then((value) {
      Product addedProduct = Product(
        title: newProduct.title,
        description: newProduct.description,
        imageUrl: newProduct.imageUrl,
        price: newProduct.price,
        id: json.decode(value.body)['name'],
      );
      _products.add(addedProduct);
      notifyListeners();
    });
  }

  void deleteProduct(String id) {
    _products.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  void updateProduct(String id, Product newProduct) {
    final prodItem = _products.indexWhere((element) => element.id == id);
    products[prodItem] = newProduct;
    notifyListeners();
  }
}
