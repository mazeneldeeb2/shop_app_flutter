class CartItem {
  final String? id;
  final String? title;
  int quantity;
  final double? price;

  CartItem({this.id, this.title, this.price, this.quantity = 1});
}
