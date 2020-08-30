import 'dart:collection';

import 'package:flutter/material.dart';

import 'product_provider.dart';

class ProductsProvider with ChangeNotifier {
  List<ProductProvider> _products = [
    ProductProvider(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    ProductProvider(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    ProductProvider(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    ProductProvider(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  // immutable list that can't be modified from elsewhere to force me
  // to use addTask(String taskTitle) that has notifyListeners to work
  // List<ProductProvider> get items => [..._products];
  // == UnmodifiableListView<Product> get ProductProviders => UnmodifiableListView(_ProductProviders);
  UnmodifiableListView<ProductProvider> get products =>
      UnmodifiableListView(_products);

  ProductProvider findProductById(String id) =>
      _products.firstWhere((element) => element.id == id);

  List<ProductProvider> get favouritesList =>
      _products.where((element) => element.isFavourite).toList();

  addProduct(ProductProvider product) {
    // we create new product as received one has null id
    final newProduct = ProductProvider(
        title: product.title,
        imageUrl: product.imageUrl,
        description: product.description,
        price: product.price,
        id: DateTime.now().toString());
    _products.insert(0, newProduct);
    notifyListeners();
  }

  updateProduct(String productId, ProductProvider updatedProduct) {
    int index = _products.indexWhere((element) => element.id == productId);
    if (index >= 0) {
      _products[index] = updatedProduct;
    } else
      print('dart mess: not found');
    notifyListeners();
  }

  deleteProduct(String productId) {
    _products.removeWhere((element) => element.id == productId);
    notifyListeners();
  }
}
