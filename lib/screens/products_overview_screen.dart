import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/components/app_drawer.dart';
import 'package:shop_app/components/badge.dart';
import 'package:shop_app/components/products_grid_view.dart';
import 'package:shop_app/screens/cart_screen.dart';

import '../models/providers/cart.dart';
import '../models/providers/products.dart';

class ProductsOverviewScreen extends StatelessWidget {
  const ProductsOverviewScreen({Key? key}) : super(key: key);
  static const String routeName = '/';
  @override
  Widget build(BuildContext context) {
    const productsItems = Provider.of<Products>;
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        actions: [
          PopupMenuButton(
              onSelected: (PopUpItemValue value) {
                if (value == PopUpItemValue.favorites) {
                  productsItems(context, listen: false).showFavorites();
                }
              },
              itemBuilder: (_) => [
                    const PopupMenuItem(
                      child: Text("Favorites"),
                      value: PopUpItemValue.favorites,
                    ),
                    const PopupMenuItem(
                      child: Text("Show All"),
                      value: PopUpItemValue.all,
                    )
                  ]),
          Consumer<Cart>(
            builder: (context, cart, child) => Badge(
              child: child,
              itemsCount: cart.itemsCount,
            ),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.pushNamed(context, CartScreen.routeName);
              },
            ),
          ),
        ],
        title: const Text("My Shop"),
      ),
      body: const ProductsGridView(),
    );
  }
}

enum PopUpItemValue {
  favorites,
  all,
}
