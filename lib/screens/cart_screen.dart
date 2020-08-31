import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/providers/order_provider.dart';
import 'package:shop_app/screens/order_screen.dart';
import 'package:shop_app/widgets/cart_item_widget.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Chip(
                    backgroundColor: Theme.of(context).primaryColor,
                    label: Text(
                      '\$${cart.orderTotal.toStringAsFixed(2)}',
                      style: TextStyle(
                        color:
                            Theme.of(context).primaryTextTheme.headline6.color,
                      ),
                    ),
                  ),
                  OrderButton(cart: cart),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, index) => CartItemWidget(
                cart.items.values.toList()[index],
                cart.items.keys.toList()[index],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final CartProvider cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      textColor: Theme.of(context).primaryColor,
      child: _isLoading ? CircularProgressIndicator() : Text('ORDER NOW'),
      // on pressed: null means disabled button
      onPressed: (widget.cart.items.isEmpty || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              try {
                await Provider.of<OrderProvider>(context, listen: false)
                    .addOrder(widget.cart.items.values.toList(),
                        widget.cart.orderTotal);
                widget.cart.clearCart();
                setState(() {
                  _isLoading = false;
                });
                Navigator.of(context).pushNamed(OrderScreen.routeName);
              } catch (e) {
                print('dart mess: $e');
              }
            },
    );
  }
}
