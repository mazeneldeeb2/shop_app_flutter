import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/models/data/product.dart';

import '../models/providers/products.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({Key? key}) : super(key: key);
  static const String routeName = "Product Details Screen";
  @override
  Widget build(BuildContext context) {
    final String productId =
        ModalRoute.of(context)!.settings.arguments as String;
    final Product productData = Provider.of<Products>(context, listen: false)
        .findProductById(productId);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(productData.title),
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Container(
                color: const Color.fromARGB(96, 80, 80, 80),
                child: Text(
                  productData.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              background: Hero(
                tag: productId,
                child: Image.network(
                  productData.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            Column(
              children: [
                Text(
                  "${productData.price}",
                  style: const TextStyle(fontSize: 20, color: Colors.grey),
                ),
                const SizedBox(
                  height: kDefaultPadding,
                ),
                Text(
                  productData.description,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 800,
                ),
              ],
            ),
          ])),
        ],
      ),
    );
  }
}
