import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:shop_app/models/data/cart_item.dart';

class Cart with ChangeNotifier {
  final String? token;

  Cart(this.token, this._cartItems);
  Map<String, CartItem>? _cartItems = {};

  Map<String, CartItem> get cartItems {
    return {..._cartItems!};
  }

  void refreshCartItems() {
    notifyListeners();
  }

  int get itemsCount => _cartItems!.values
      .fold(0, (quantity, cardItem) => cardItem.quantity + quantity);

  void addCartItem({
    required String productId,
    required String title,
    required double price,
  }) {
    if (_cartItems!.containsKey(productId)) {
      _cartItems!.update(
          productId,
          (value) => CartItem(
                id: value.id,
                title: value.title,
                price: value.price,
                quantity: value.quantity + 1,
              ));
    } else {
      _cartItems!.putIfAbsent(
          productId,
          () => CartItem(
                id: productId,
                title: title,
                price: price,
                quantity: 1,
              ));
    }
  }

  int get cartItemCount {
    return _cartItems!.length;
  }

  double get totalAmount {
    double totalAmount = 0.0;
    _cartItems!.forEach((key, cartItem) {
      totalAmount += cartItem.price! * cartItem.quantity;
    });

    return totalAmount;
  }

  void removeItem(String id) {
    _cartItems!.remove(id);
    notifyListeners();
  }

  void clearCart() {
    _cartItems = {};
    notifyListeners();
  }

  void removeSingleItem(String id) {
    if (_cartItems!.containsKey(id)) {
      _cartItems![id]!.quantity = _cartItems![id]!.quantity - 1;
    } else {
      removeItem(id);
    }
    notifyListeners();
  }
}
