import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/widgets/badge.dart';
import 'package:shop_app/widgets/products_grid.dart';

enum Filters { Favourites, All }

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showFavourites = false;

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
              onPressed: () {},
            ),
          )
        ],
      ),
      body: ProductsGrid(_showFavourites),
    );
  }
}
