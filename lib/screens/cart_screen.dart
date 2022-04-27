import 'package:flutter/material.dart';

import '../components/cart_list_view.dart';
import '../components/total_amount_card_cart.dart';

class CartScreen extends StatelessWidget {
  static const String routeName = "/cartScreen";
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart"),
      ),
      body: Column(
        children: const [
          TotalAmountCartCard(),
          CartListView(),
        ],
      ),
    );
  }
}
