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
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
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

  clearCart() {
    _items.clear();
    notifyListeners();
  }
}
