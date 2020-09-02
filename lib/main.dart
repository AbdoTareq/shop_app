import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth_provider.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/providers/order_provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/order_screen.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          // use ChangeNotifierProvider instead of ChangeNotifierProvider.value
          // if u will instantiate a class like here ProductsProvider() for cashing reasons
          create: (BuildContext context) => AuthProvider(),
        ),
        // this is used when provider depends on another like this case
        // ProductsProvider & the rest of providers depend on AuthProvider
        // (products need token to fetch data from backend)
        ChangeNotifierProxyProvider<AuthProvider, ProductsProvider>(
          update: (BuildContext context, auth, ProductsProvider previous) =>
              ProductsProvider(
                  auth.token, previous == null ? [] : previous.products),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => OrderProvider(),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (BuildContext context, auth, Widget child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'MyShop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          home: auth.isAuth() ? ProductsOverviewScreen() : AuthScreen(),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrderScreen.routeName: (ctx) => OrderScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
