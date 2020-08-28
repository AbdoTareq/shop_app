import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart_provider.dart';

class CartItemWidget extends StatelessWidget {
  final cartItem;
  final productId;

  CartItemWidget(this.cartItem, this.productId);

  @override
  Widget build(BuildContext context) {
    final cartProv = Provider.of<CartProvider>(context);
    return Dismissible(
      key: ValueKey(productId),
      onDismissed: (dismissDirection) {
        cartProv.removeItem(productId);
      },
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Are you sure?'),
                  content: Text('Do you want to remove the item?'),
                  actions: [
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Text(
                          'No',
                          style: TextStyle(color: Colors.red),
                        )),
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: Text('Yes')),
                  ],
                ));
      },
      background: Container(
        alignment: Alignment.centerRight,
        color: Theme.of(context).errorColor,
        margin: EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            Icons.delete,
            color: Colors.white,
            size: 34,
          ),
        ),
      ),
      child: Card(
        margin: EdgeInsets.all(10),
        child: ListTile(
          leading: CircleAvatar(
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: FittedBox(child: Text('\$${cartItem.price}')),
            ),
          ),
          title: Text(cartItem.title),
          subtitle: Text('Total: \$${(cartItem.price) * cartItem.quantity}'),
          trailing: Text('${cartItem.quantity}x'),
        ),
      ),
    );
  }
}
