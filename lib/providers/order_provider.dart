import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/cart_item.dart';
import 'package:shop_app/models/order_item.dart';

class OrderProvider with ChangeNotifier {
  List<OrderItem> _orders = [];

  final String token;

  OrderProvider(this.token, this._orders);

  // immutable list that can't be modified from elsewhere to force me
  // to use addTask(String taskTitle) that has notifyListeners to work
  // List<ProductProvider> get items => [..._products];
  // == UnmodifiableListView<Product> get ProductProviders => UnmodifiableListView(_ProductProviders);
  UnmodifiableListView<OrderItem> get orders => UnmodifiableListView(_orders);

  // important method teach how to map a list map input to list<object>
  Future<void> fetchAndSetOrders() async {
    final url =
        'https://flutter-shop-app-3f55f.firebaseio.com/orders.json?auth=$token';
    final response = await http.get(url);
    final responseBodyMap = json.decode(response.body) as Map<String, dynamic>;
    if (responseBodyMap == null) {
      return;
    }
    print('dart mess: $responseBodyMap');
    List<OrderItem> loadedOrders = [];
    responseBodyMap.forEach((key, order) {
      loadedOrders.add(OrderItem(
        id: key,
        amount: order['amount'],
        dateTime: DateTime.parse(order['dateTime']),
        productsList: (order['productsList'] as List<dynamic>)
            .map((cartItem) => CartItem(
                  id: cartItem['id'],
                  price: cartItem['price'],
                  quantity: cartItem['quantity'],
                  title: cartItem['title'],
                ))
            .toList(),
      ));
    });
    print('dart mess: $loadedOrders');
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  // important method teach how to map list<object> output to list map
  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url =
        'https://flutter-shop-app-3f55f.firebaseio.com/orders.json?auth=$token';
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
