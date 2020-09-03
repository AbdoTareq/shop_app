import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/user_products_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  @override
  Widget build(BuildContext context) {
    print('dart mess: building');
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      drawer: AppDrawer(),
      // note that consumer must be used with future builder instead of final products = Provider.of<ProductsProvider>(context).products;
      // if not will enter infinite loop
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Consumer<ProductsProvider>(
                        builder: (BuildContext context, productsData,
                                Widget child) =>
                            ListView.builder(
                          itemCount: productsData.products.length,
                          itemBuilder: (BuildContext context, int index) =>
                              UserProductItem(productsData.products[index]),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false)
        .fetchAndSetProducts(true);
  }
}
