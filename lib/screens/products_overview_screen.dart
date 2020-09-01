import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/badge.dart';
import 'package:shop_app/widgets/products_grid.dart';

enum Filters { Favourites, All }

class ProductsOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop App'),
        actions: [
          PopupMenuButton(
            onSelected: (Filters selectedFilters) {
              if (selectedFilters == Filters.Favourites) {
                Provider.of<ProductsProvider>(context, listen: false)
                    .toggleFavourites();
              } else {
                Provider.of<ProductsProvider>(context, listen: false)
                    .toggleFavourites();
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: Filters.Favourites,
                child: Text('Show Favourites'),
              ),
              PopupMenuItem(
                value: Filters.All,
                child: Text('Show all'),
              ),
            ],
          ),
          Consumer<CartProvider>(
            builder: (context, cart, ch) => Badge(
              value: cart.cartSize.toString(),
              // not to build IconButton on every change
              child: ch,
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          )
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<ProductsProvider>(context, listen: false)
            .fetchAndSetProducts(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.error != null) {
            return Center(
              child: Text('Error occurred,\n ${snapshot.error}'),
            );
          } else
            return ProductsGrid();
        },
      ),
      drawer: AppDrawer(),
    );
  }
}
