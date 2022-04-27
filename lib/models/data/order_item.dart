import 'package:shop_app/models/data/cart_item.dart';

class OrderItem {
  final String? id;
  final double? amount;
  final List<CartItem>? products;
  final DateTime? dateTime;

  OrderItem({this.id, this.amount, this.dateTime, this.products});
}
