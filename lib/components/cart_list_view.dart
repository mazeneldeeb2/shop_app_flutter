import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/providers/cart.dart';
import 'cart_item_tile.dart';

class CartListView extends StatelessWidget {
  const CartListView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<Cart>(context);
    final cartList = cartProvider.cartItems.values.toList();
    return Expanded(
      child: ListView.builder(
        itemBuilder: (context, index) => CartItemCard(
          id: cartList[index].id,
          productId: cartProvider.cartItems.keys.toList()[index],
          title: cartList[index].title,
          quantity: cartList[index].quantity,
          price: cartList[index].price,
        ),
        itemCount: cartProvider.cartItemCount,
      ),
    );
  }
}
