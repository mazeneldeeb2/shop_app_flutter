import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

import '../data/product.dart';

class Products with ChangeNotifier {
  bool _emptyData = false;
  List<Product> _products = [];
  bool _showFavorites = false;
  bool get showFavoritesValue {
    return _showFavorites;
  }

  bool get emptyData {
    return _emptyData;
  }

  static const urlString =
      'https://flutter-shop-app-96c3a-default-rtdb.europe-west1.firebasedatabase.app/products.json';

  final url = Uri.parse(urlString);
  Future<void> fetchProducts() async {
    http.Response response;
    try {
      response = await http.get(url);
    } catch (error) {
      rethrow;
    }
    if (json.decode(response.body) == null) {
      _emptyData = true;
      notifyListeners();
    } else {
      try {
        _emptyData = false;
        notifyListeners();
        var loadedProduct = json.decode(response.body) as Map<String, dynamic>;
        final List<Product> loadedProducts = [];
        loadedProduct.forEach((productId, productData) {
          loadedProducts.add(Product(
            id: productId,
            title: productData['title'],
            price: productData['price'],
            isFavourite: productData['isFavourite'],
            imageUrl: productData['imageUrl'],
            description: productData['description'],
          ));
        });
        _products = loadedProducts;
        notifyListeners();
      } catch (error) {
        rethrow;
      }
    }
  }

  List<Product> _favorites = [];
  List<Product> get favourites {
    _favorites = _products.where((product) => product.isFavourite).toList();
    return [..._favorites];
  }

  List<Product> get products {
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

  Future<void> addProduct(Product newProduct) async {
    try {
      var response = await http.post(
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
      );

      Product addedProduct = Product(
        title: newProduct.title,
        description: newProduct.description,
        imageUrl: newProduct.imageUrl,
        price: newProduct.price,
        id: json.decode(response.body)['name'],
      );
      _products.add(addedProduct);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  void deleteProduct(String id) async {
    final Uri productUrl = Uri.parse(
        'https://flutter-shop-app-96c3a-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json');
    final existingProductIndex =
        _products.indexWhere((element) => element.id == id);
    var exisitngProduct = _products[existingProductIndex];
    http.delete(productUrl).catchError((_) {
      _products.insert(existingProductIndex, exisitngProduct);
      notifyListeners();
    });
    _products.removeAt(existingProductIndex);

    notifyListeners();
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodItem = _products.indexWhere((element) => element.id == id);
    if (prodItem >= 0) {
      final Uri productUrl = Uri.parse(
          'https://flutter-shop-app-96c3a-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json');
      await http.patch(
        productUrl,
        body: json.encode(
          {
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl,
          },
        ),
      );
      products[prodItem] = newProduct;
      notifyListeners();
    }
  }
}
