import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';

import 'product_item.dart';

class ProductsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    final products = Provider.of<ProductsProvider>(context).showFavourites
        ? productsData.favouritesList
        : productsData.products;
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10),
      itemCount: products.length,
      itemBuilder: (ctx, i) =>
          // use ChangeNotifierProvider.value instead of ChangeNotifierProvider
          // if u will instantiate a class like here ProductsProvider() for cashing reasons
          // & it's recommended to use it with list views
          ChangeNotifierProvider.value(
              value: products[i], child: ProductItem()),
    );
  }
}
