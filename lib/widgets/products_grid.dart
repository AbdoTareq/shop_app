import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product_provider.dart';
import 'package:shop_app/providers/products_provider.dart';

import 'product_item.dart';

class ProductsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<ProductProvider> products =
        Provider.of<ProductsProvider>(context).products;
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider(
          create: (BuildContext context) => products[i], child: ProductItem()),
    );
  }
}
