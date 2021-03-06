
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/components/app_drawer.dart';
import 'package:shop_app/components/user_product_item.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/models/providers/products.dart';
import 'package:shop_app/screens/edit_product_screen.dart';

class UserProductScreen extends StatelessWidget {
  const UserProductScreen({
    Key? key,
  }) : super(key: key);
  static const String routeName = "/userProductScreen";

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchProducts(true);
    return Future.value();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text("Your Products"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, EditProductScreen.routeName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: FutureBuilder(
          future: _refreshProducts(context),
          builder: (context, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : RefreshIndicator(
                  onRefresh: () => _refreshProducts(context),
                  child: Consumer<Products>(
                    builder: (context, productsProvider, child) =>
                        ListView.builder(
                      itemCount: productsProvider.products.length,
                      itemBuilder: (context, index) => Column(
                        children: [
                          UserProductItem(
                            id: productsProvider.products[index].id,
                            title: productsProvider.products[index].title,
                            imageUrl: productsProvider.products[index].imageUrl,
                          ),
                          const Divider(),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
