import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/models/data/product.dart';
import 'package:shop_app/models/providers/auth.dart';
import 'package:shop_app/screens/product_details_screen.dart';

import '../models/providers/cart.dart';
import '../models/providers/products.dart';

class ProductItem extends StatelessWidget {
  const ProductItem(
      {Key? key,
      required this.id,
      required this.imageUrl,
      required this.title,
      required this.price})
      : super(key: key);
  final String imageUrl;
  final String id;
  final String title;
  final double price;
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<Cart>(context, listen: false);
    const productProvider = Provider.of<Product>;
    final auth = Provider.of<Auth>(context, listen: false);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kDefaultPadding),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.7),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3))
        ],
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, ProductDetailsScreen.routeName,
              arguments: id);
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(kDefaultPadding),
          child: GridTile(
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
            footer: GridTileBar(
              trailing: IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                onPressed: () {
                  Product addedProduct =
                      productProvider(context, listen: false);
                  cartProvider.addCartItem(
                    productId: addedProduct.id,
                    title: addedProduct.title,
                    price: addedProduct.price,
                  );
                  cartProvider.refreshCartItems();
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Add ${addedProduct.title} to cart"),
                      duration: const Duration(seconds: 2),
                      action: SnackBarAction(
                          label: "Undo",
                          onPressed: () {
                            cartProvider.removeSingleItem(addedProduct.id);
                          }),
                    ),
                  );
                },
              ),
              leading: IconButton(
                icon: Icon(
                  productProvider(context).isFavourite
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                onPressed: () {
                  productProvider(context, listen: false)
                      .toggleIsFavouriteStatus(
                    auth.token,
                    auth.userId,
                  );

                  Provider.of<Products>(context, listen: false)
                      .refreshProductsList();
                },
              ),
              backgroundColor: Colors.black87,
              title: Text(
                title,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
