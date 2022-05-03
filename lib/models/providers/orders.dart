import 'package:flutter/cupertino.dart';
import 'package:shop_app/models/data/cart_item.dart';
import 'package:shop_app/models/data/order_item.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/providers/cart.dart';

class Orders with ChangeNotifier {
  static const urlString =
      'https://flutter-shop-app-96c3a-default-rtdb.europe-west1.firebasedatabase.app/orders.json';

  final url = Uri.parse(urlString);
  // ignore: prefer_final_fields
  List<OrderItem> _orders = [];
  bool _emptyOrders = true;
  bool get emptyOrders {
    return _emptyOrders;
  }

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> newCartProducts, double total) async {
    final timeStamp = DateTime.now();
    http.Response response;
    try {
      response = await http.post(
        url,
        body: json.encode(
          {
            'amount': total,
            'dateTime': timeStamp.toIso8601String(),
            'products': newCartProducts
                .map((cartItem) => {
                      'id': cartItem.id,
                      'quantity': cartItem.quantity,
                      'price': cartItem.price,
                      'title': cartItem.title,
                    })
                .toList(),
          },
        ),
      );
    } catch (error) {
      rethrow;
    }

    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        dateTime: timeStamp,
        products: newCartProducts,
      ),
    );
    notifyListeners();
  }

  Future<void> fetchOrders() async {
    http.Response response;
    try {
      response = await http.get(url).timeout(const Duration(seconds: 3));
    } catch (error) {
      rethrow;
    }
    if (json.decode(response.body) != null) {
      _emptyOrders = false;
      Map<String, dynamic> data =
          json.decode(response.body) as Map<String, dynamic>;
      final List<OrderItem> fetchedOrders = [];
      data.forEach((orderId, order) {
        fetchedOrders.add(OrderItem(
          id: orderId,
          dateTime: DateTime.parse(order["dateTime"]),
          amount: order["amount"],
          products: (order['products'] as List<dynamic>).map((item) {
            return CartItem(
              id: item['id'],
              price: item['price'],
              quantity: item['quantity'],
              title: item['title'],
            );
          }).toList(),
        ));
      });
      _orders = fetchedOrders.reversed.toList();
      notifyListeners();
    }
  }
}
