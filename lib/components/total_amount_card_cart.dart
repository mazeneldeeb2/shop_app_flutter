import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/providers/orders.dart';

import '../constants.dart';
import '../models/providers/cart.dart';

class TotalAmountCartCard extends StatelessWidget {
  const TotalAmountCartCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<Cart>(context);
    final orderProvider = Provider.of<Orders>(context, listen: false);
    return Card(
      margin: const EdgeInsets.all(kDefaultPadding),
      child: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const Text(
            "Total",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          const Spacer(),
          Consumer(
            builder: (BuildContext context, value, Widget? child) => Chip(
              backgroundColor: kPrimaryColor,
              label: Text(
                cartProvider.totalAmount.toStringAsFixed(2),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          OrderButton(cartProvider: cartProvider, orderProvider: orderProvider),
        ]),
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cartProvider,
    required this.orderProvider,
  }) : super(key: key);

  final Cart cartProvider;
  final Orders orderProvider;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Padding(
            padding: EdgeInsets.only(
              left: kDefaultPadding,
            ),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : TextButton(
            child: const Text(
              "Order Now",
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            onPressed: widget.cartProvider.cartItems.isEmpty
                ? null
                : () async {
                    setState(() {
                      _isLoading = true;
                    });
                    await widget.orderProvider.addOrder(
                        widget.cartProvider.cartItems.values.toList(),
                        widget.cartProvider.totalAmount);
                    setState(() {
                      _isLoading = false;
                    });
                    widget.cartProvider.clearCart();
                  },
          );
  }
}
