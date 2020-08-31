import 'dart:collection';
import 'dart:convert';
import 'package:http/http.dart' as http;

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

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    const url = 'https://flutter-shop-app-3f55f.firebaseio.com/orders.json';
    final timeStamp = DateTime.now();

    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'dateTime': timeStamp.toIso8601String(),
          'productsList': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'price': cp.price,
                    'quantity': cp.quantity,
                  })
              .toList(),
        }));
    print('dart mess: ${json.decode(response.body)}');
    _orders.insert(
        0,
        OrderItem(
            id: json.decode(response.body)['name'],
            amount: total,
            dateTime: timeStamp,
            productsList: cartProducts));
    notifyListeners();
  }
}
