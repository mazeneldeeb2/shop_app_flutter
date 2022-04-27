import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/components/app_drawer.dart';
import 'package:shop_app/models/providers/orders.dart';

import '../components/order_card.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);
  static const String routeName = "/orderScreen";
  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<Orders>(context);
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text("Your Orders"),
      ),
      body: ListView.builder(
          itemCount: ordersProvider.orders.length,
          itemBuilder: (context, index) => OrderCard(
                order: ordersProvider.orders[index],
              )),
    );
  }
}
