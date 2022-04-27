import 'package:flutter/cupertino.dart';
import 'package:shop_app/models/data/cart_item.dart';
import 'package:shop_app/models/data/order_item.dart';

class Orders with ChangeNotifier {
  // ignore: prefer_final_fields
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> newCartProducts, double total) {
    _orders.insert(
      0,
      OrderItem(
        id: DateTime.now().toString(),
        amount: total,
        dateTime: DateTime.now(),
        products: newCartProducts,
      ),
    );
    notifyListeners();
  }
}
