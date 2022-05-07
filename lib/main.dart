import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/models/providers/auth.dart';
import 'package:shop_app/models/providers/cart.dart';
import 'package:shop_app/models/providers/orders.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/order_screen.dart';
import 'package:shop_app/screens/product_details_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';

import 'models/providers/products.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}
// final authUri = Uri.https(
     //   'identitytoolkit.googleapis.com', '/v1/accounts:$urlSegment', params);
     //static const params = {
    //'key': 'AIzaSyBeC0dKXtoCu3r4gyrQX0W5Mf3VvDLoDYw',
  //};
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => Orders("", "", []),
          update: (context, auth, previousOrders) =>
              Orders(auth.token, auth.userId, previousOrders?.orders),
        ),
        ChangeNotifierProxyProvider<Auth, Cart>(
          create: (_) => Cart("", {}),
          update: (context, auth, previousCart) =>
              Cart(auth.token, previousCart?.cartItems),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (context) => Products(
            "",
            "",
            [],
          ),
          update: (context, auth, previousProducts) => Products(
              auth.token , auth.userId , previousProducts!.products),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: kPrimaryColor,
              secondary: kSecondaryColor,
            ),
          ),
          home: auth.isAuth
              ? const ProductsOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (context, authSnapShot) =>
                      authSnapShot.connectionState == ConnectionState.waiting
                          ? const SplashScreen()
                          : const AuthScreen()),
          routes: {
            ProductDetailsScreen.routeName: (context) =>
                const ProductDetailsScreen(),
            CartScreen.routeName: (context) => const CartScreen(),
            OrdersScreen.routeName: (context) => const OrdersScreen(),
            UserProductScreen.routeName: (context) => const UserProductScreen(),
            EditProductScreen.routeName: (context) => const EditProductScreen(),
            AuthScreen.routeName: (context) => const AuthScreen(),
          },
        ),
      ),
    );
  }
}
