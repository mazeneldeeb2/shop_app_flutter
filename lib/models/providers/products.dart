import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

import '../data/product.dart';

class Products with ChangeNotifier {
  final String? token;
  final String? userId;
  Products(this.token, this.userId, this._products);
  bool _emptyData = false;
  List<Product>? _products = [];
  bool _showFavorites = false;
  bool get showFavoritesValue {
    return _showFavorites;
  }

  bool get emptyData {
    return _emptyData;
  }

  Future<void> fetchProducts([bool filterByUser = false]) async {
    final String filter =
        filterByUser ? 'orderBy="createdBy"&equalTo="$userId"' : '';
    Uri uri = Uri.parse(
        'https://flutter-shop-app-96c3a-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=$token&$filter');
    http.Response response;
    try {
      response = await http.get(uri);
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

        uri = Uri.parse(
            'https://flutter-shop-app-96c3a-default-rtdb.europe-west1.firebasedatabase.app/userFavorites/$userId.json?auth=$token');
        final favoriteResponse = await http.get(uri);
        final favoriteData = json.decode(favoriteResponse.body);

        final List<Product> loadedProducts = [];

        loadedProduct.forEach((productId, productData) {
          loadedProducts.add(Product(
            id: productId,
            title: productData['title'],
            price: productData['price'],
            imageUrl: productData['imageUrl'],
            isFavourite: favoriteData == null
                ? false
                : favoriteData[productId] == null
                    ? false
                    : favoriteData[productId]['isFavourite'] ?? false,
            description: productData['description'],
          ));
        });
        _products = loadedProducts;
        notifyListeners();
      } catch (error) {
        log(error.toString());
        rethrow;
      }
    }
  }

  List<Product> _favorites = [];
  List<Product> get favourites {
    _favorites = _products!.where((product) => product.isFavourite).toList();
    return [..._favorites];
  }

  List<Product> get products {
    return [..._products!];
  }

  void refreshProductsList() {
    notifyListeners();
  }

  void showFavorites() {
    _favorites = _products!.where((product) => product.isFavourite).toList();
    _showFavorites = true;
    notifyListeners();
  }

  void showAll() {
    _showFavorites = false;
    notifyListeners();
  }

  Product findProductById(String id) {
    return _products!.firstWhere((product) => product.id == id);
  }

  Future<void> addProduct(Product newProduct) async {
    final urlString =
        'https://flutter-shop-app-96c3a-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=$token';

    final url = Uri.parse(urlString);
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
            'createdBy': userId,
          },
        ),
      );

      Product addedProduct = Product(
        title: newProduct.title,
        description: newProduct.description,
        imageUrl: newProduct.imageUrl,
        price: newProduct.price,
        isFavourite: newProduct.isFavourite,
        id: json.decode(response.body)['name'],
      );
      _products!.add(addedProduct);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  void deleteProduct(String id) async {
    final Uri productUrl = Uri.parse(
        'https://flutter-shop-app-96c3a-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json?auth=$token');
    final existingProductIndex =
        _products!.indexWhere((element) => element.id == id);
    var exisitngProduct = _products![existingProductIndex];
    http.delete(productUrl).catchError((_) {
      _products!.insert(existingProductIndex, exisitngProduct);
      notifyListeners();
    });
    _products!.removeAt(existingProductIndex);

    notifyListeners();
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodItem = _products!.indexWhere((element) => element.id == id);
    if (prodItem >= 0) {
      final Uri productUrl = Uri.parse(
          'https://flutter-shop-app-96c3a-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json?auth=$token');
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
