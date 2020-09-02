import 'package:flutter/foundation.dart';
import 'package:shop_app/models/cart_item.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  int get cartSize {
    return _items.length;
  }

  double get orderTotal {
    var total = 0.0;
    try {
      _items.forEach((key, cartItem) {
        total += cartItem.price * cartItem.quantity;
        print('dart mess: price ${cartItem.price}');
        print('dart mess: quan ${cartItem.quantity}');
      });
    } catch (e) {
      print('dart mess: ${_items}');
      print(e);
    }
    return total;
  }

  addItem(String productId, String title, double price) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existing) => CartItem(
              id: existing.id,
              title: existing.title,
              price: existing.price,
              quantity: existing.quantity + 1));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              price: price,
              quantity: 1));
    }
    notifyListeners();
  }

  removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].quantity > 1) {
      _items.update(
          productId,
          (value) => CartItem(
                id: value.id,
                title: value.title,
                price: value.price,
                quantity: value.quantity - 1,
              ));
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  clearCart() {
    _items.clear();
    notifyListeners();
  }
}
