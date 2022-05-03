import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/components/app_drawer.dart';
import 'package:shop_app/models/providers/orders.dart';

import '../components/order_card.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);
  static const String routeName = "/orderScreen";

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool _isInit = true;
  bool _isLoading = false;
  bool _isFailed = false;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Orders>(context, listen: false)
          .fetchOrders()
          .catchError((onError) {
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
      }).then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<Orders>(context);

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text("Your Orders"),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _isFailed
              ? const Center(
                  child: Text(
                    "Please make sure you are connected to internet and restart the app",
                  ),
                )
              : ordersProvider.emptyOrders
                  ? const Center(
                      child: Text(
                        "You have no orders",
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: ordersProvider.orders.length,
                      itemBuilder: (context, index) => OrderCard(
                            order: ordersProvider.orders[index],
                          )),
    );
  }
}
