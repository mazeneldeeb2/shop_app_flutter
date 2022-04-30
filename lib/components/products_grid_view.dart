import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../models/providers/products.dart';
import 'product_item.dart';

class ProductsGridView extends StatefulWidget {
  const ProductsGridView({Key? key}) : super(key: key);

  @override
  State<ProductsGridView> createState() => _ProductsGridViewState();
}

class _ProductsGridViewState extends State<ProductsGridView> {
  bool _isInit = true;
  bool _isLoading = false;
  bool _isFailed = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchProducts().catchError((error) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('An error occurred!'),
            content: const Text('Something went wrong.'),
            actions: <Widget>[
              TextButton(
                child: const Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                  setState(() {
                    _isFailed = true;
                  });
                },
              )
            ],
          ),
        );
      }).then((_) => setState(() {
            _isLoading = false;
          }));

      _isInit = false;
      super.didChangeDependencies();
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context).products;
    return Provider.of<Products>(context).emptyData
        ? const Center(
            child: Text(
              "There is no products right now, please come back later",
            ),
          )
        : _isFailed
            ? const Center(
                child: Text(
                  "Please make sure you are connected to internet and restart the app",
                ),
              )
            : _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(kDefaultPadding),
                    itemCount: products.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3 / 2,
                      crossAxisSpacing: kDefaultPadding,
                      mainAxisSpacing: kDefaultPadding,
                    ),
                    itemBuilder: (context, index) =>
                        ChangeNotifierProvider.value(
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
