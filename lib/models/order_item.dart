import 'package:flutter/material.dart';
import 'package:shop_app/models/cart_item.dart';

class OrderItem {
  final String id;
  final int amount;
  final List<CartItem> productsList;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.productsList,
    @required this.dateTime,
  });
}
