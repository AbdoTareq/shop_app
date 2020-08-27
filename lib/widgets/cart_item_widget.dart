import 'package:flutter/material.dart';

class CartItemWidget extends StatelessWidget {
  final cartItem;

  CartItemWidget(this.cartItem);

  @override
  Widget build(BuildContext context) {
    return Card(
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
    );
  }
}
