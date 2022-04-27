import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../models/providers/products.dart';
import 'product_item.dart';

class ProductsGridView extends StatelessWidget {
  const ProductsGridView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context).products;
    return GridView.builder(
      padding: const EdgeInsets.all(kDefaultPadding),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: kDefaultPadding,
        mainAxisSpacing: kDefaultPadding,
      ),
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
        value: products[index],
        child: ProductItem(
          title: products[index].title,
          id: products[index].id,
          price: products[index].price,
          imageUrl: products[index].imageUrl,
        ),
      ),
    );
  }
}
