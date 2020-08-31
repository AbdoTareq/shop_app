import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product_provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final ProductProvider product;

  UserProductItem(this.product);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(product.imageUrl),
          ),
          title: Text(product.title),
          trailing: Container(
            width: 100,
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(EditProductScreen.routeName,
                        arguments: product.id);
                  },
                  icon: Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () async {
                    try {
                      await Provider.of<ProductsProvider>(context,
                              listen: false)
                          .deleteProduct(product.id);
                    } catch (e) {
                      // it made scaffold as a variable not to be built during catch(fail)
                      scaffold.showSnackBar(SnackBar(
                        content: Text(
                          e.toString(),
                          textAlign: TextAlign.center,
                        ),
                      ));
                      print(e);
                    }
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(),
      ],
    );
  }
}
