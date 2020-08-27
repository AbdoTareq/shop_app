import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:shop_app/models/cart_item.dart';
import 'package:shop_app/models/order_item.dart';

class OrderProvider with ChangeNotifier {
  List<OrderItem> _orders = [];

  // immutable list that can't be modified from elsewhere to force me
  // to use addTask(String taskTitle) that has notifyListeners to work
  // List<ProductProvider> get items => [..._products];
  // == UnmodifiableListView<Product> get ProductProviders => UnmodifiableListView(_ProductProviders);
  UnmodifiableListView<OrderItem> get orders => UnmodifiableListView(_orders);

  addProduct(List<CartItem> cartProducts, int total) {
    _orders.insert(
        0,
        OrderItem(
            id: DateTime.now().toString(),
            amount: total,
            dateTime: DateTime.now(),
            productsList: cartProducts));
    notifyListeners();
  }
}
