import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/order_provider.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_item_widget.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    // make infinite loop as it's listening to any changes then rebuild the widget
//    final orders = Provider.of<OrderProvider>(context).orders;
    return Scaffold(
      appBar: AppBar(
        title: Text('Place Order'),
      ),
      // this is a better replacement to a state full widget with loading variable
      body: FutureBuilder(
        // this provider will get the data then notifyListener which will build the widget then final provider will be created
        future: Provider.of<OrderProvider>(context, listen: false)
            .fetchAndSetOrders(),
        builder: (BuildContext ctx, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Error occurred, \n ${snapshot.error}'),
              ),
            );
          } else {
            // we used consumer down here to stop infinite loop building
            return Consumer<OrderProvider>(
              builder: (BuildContext context, ordersData, Widget child) {
                return ListView.builder(
                  itemCount: ordersData.orders.length,
                  itemBuilder: (BuildContext context, int index) {
                    return OrderItemWidget(ordersData.orders[index]);
                  },
                );
              },
            );
          }
        },
      ),
      drawer: AppDrawer(),
    );
  }
}
