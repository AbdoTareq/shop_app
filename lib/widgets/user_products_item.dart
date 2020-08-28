import 'package:flutter/material.dart';
import 'package:shop_app/providers/product_provider.dart';

class UserProductItem extends StatelessWidget {
  final ProductProvider product;

  UserProductItem(this.product);

  @override
  Widget build(BuildContext context) {
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
                  onPressed: () {},
                  icon: Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () {},
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
