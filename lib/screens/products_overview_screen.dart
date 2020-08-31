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

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showFavourites = false;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    // we must use listen false or it will not work also we can use didChangeDependencies()
    // instead with a flag to make it run only once
    // also we can use delayed fun with delay set to 0
//    Future.delayed(Duration.zero).then((value) =>
//        Provider.of<ProductsProvider>(context, listen: false)
//            .fetchAndSetProducts());
    setState(() {
      _isLoading = true;
    });
    Provider.of<ProductsProvider>(context, listen: false)
        .fetchAndSetProducts()
        .catchError((e) {
      return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text('An error occurred'),
                content: Text(e.toString()),
                actions: [
                  FlatButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Text('Ok'),
                  )
                ],
              ));
    }).then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop App'),
        actions: [
          PopupMenuButton(
            onSelected: (Filters selectedFilters) {
              setState(() {
                if (selectedFilters == Filters.Favourites) {
                  setState(() {
                    _showFavourites = true;
                  });
                } else {
                  setState(() {
                    _showFavourites = false;
                  });
                }
              });
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
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showFavourites),
      drawer: AppDrawer(),
    );
  }
}
