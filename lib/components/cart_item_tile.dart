import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/constants.dart';

import '../models/providers/cart.dart';

class CartItemCard extends StatelessWidget {
  final int? productId;

  const CartItemCard(
      {Key? key,
      this.productId,
      this.id,
      this.price,
      this.quantity,
      this.title})
      : super(key: key);
  final int? id;
  final String? title;
  final double? price;
  final int? quantity;

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<Cart>(context, listen: false);
    return Dismissible(
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Are you sure?"),
            content: const Text("Do you want to remove the item for the cart?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text("No"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: const Text("Yes"),
              ),
            ],
          ),
        );
      },
      key: ValueKey(id),
      onDismissed: (_) {
        cartProvider.removeItem(productId);
      },
      direction: DismissDirection.endToStart,
      background: Container(
          color: Colors.white,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: kDefaultPadding),
          margin: const EdgeInsets.symmetric(
            horizontal: kDefaultPadding,
            vertical: kDefaultPadding / 2,
          ),
          child: const Icon(
            Icons.delete_forever,
            color: kPrimaryColor,
            size: 40,
          )),
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: kDefaultPadding,
          vertical: kDefaultPadding / 2,
        ),
        child: Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: ListTile(
            leading: CircleAvatar(
                backgroundColor: kPrimaryColor,
                radius: 35,
                child: FittedBox(
                    child: Text(
                  "\$$price",
                  style: const TextStyle(color: Colors.white),
                ))),
            title: Text("$title"),
            subtitle: Text("\$${(price! * quantity!)}"),
            trailing: Text("$quantity x"),
          ),
        ),
      ),
    );
  }
}
