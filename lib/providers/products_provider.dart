import 'dart:collection';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:shop_app/models/http_exception.dart';

import 'product_provider.dart';

class ProductsProvider with ChangeNotifier {
  List<ProductProvider> _products = [
//    ProductProvider(
//      id: 'p1',
//      title: 'Red Shirt',
//      description: 'A red shirt - it is pretty red!',
//      price: 29.99,
//      imageUrl:
//          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
//    ),
//    ProductProvider(
//      id: 'p2',
//      title: 'Trousers',
//      description: 'A nice pair of trousers.',
//      price: 59.99,
//      imageUrl:
//          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
//    ),
//    ProductProvider(
//      id: 'p3',
//      title: 'Yellow Scarf',
//      description: 'Warm and cozy - exactly what you need for the winter.',
//      price: 19.99,
//      imageUrl:
//          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
//    ),
//    ProductProvider(
//      id: 'p4',
//      title: 'A Pan',
//      description: 'Prepare any meal you want.',
//      price: 49.99,
//      imageUrl:
//          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
//    ),
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

  Future<void> fetchAndSetProducts() async {
    const url = 'https://flutter-shop-app-3f55f.firebaseio.com/products.json';
    try {
      final response = await http.get(url);
      print('dart mess: ${response.body}');
      final responseBodyMap =
          json.decode(response.body) as Map<String, dynamic>;
      List<ProductProvider> loadedProducts = [];
      responseBodyMap.forEach((key, product) {
        loadedProducts.add(ProductProvider(
          id: key,
          title: product['title'],
          price: product['price'],
          description: product['description'],
          imageUrl: product['imageUrl'],
          isFavourite: product['isFavourite'],
        ));
      });
      print('dart mess: $loadedProducts');
      _products = loadedProducts;
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> addProduct(ProductProvider product) async {
    const url = 'https://flutter-shop-app-3f55f.firebaseio.com/products.json';
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'price': product.price,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'isFavourite': product.isFavourite,
          }));
      print('dart mess: ${json.decode(response.body)}');
      // we create new product as received one has null id
      final newProduct = ProductProvider(
        title: product.title,
        imageUrl: product.imageUrl,
        description: product.description,
        price: product.price,
        // id is stored inside response map
        id: json.decode(response.body)['name'],
      );
      _products.insert(0, newProduct);
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> updateProduct(
      String productId, ProductProvider updatedProduct) async {
    int index = _products.indexWhere((element) => element.id == productId);
    if (index >= 0) {
      final url =
          'https://flutter-shop-app-3f55f.firebaseio.com/products/$productId.json';
      await http.patch(url,
          body: jsonEncode({
            'title': updatedProduct.title,
            'price': updatedProduct.price,
            'description': updatedProduct.description,
            'imageUrl': updatedProduct.imageUrl,
            'isFavourite': updatedProduct.isFavourite,
          }));
      _products[index] = updatedProduct;
    } else
      print('dart mess: not found');
    notifyListeners();
  }

  Future<void> deleteProduct(String productId) async {
    final url =
        'https://flutter-shop-app-3f55f.firebaseio.com/products/$productId.json';
    // these 2 lines for rollback if delete failed called (optimistic delete)
    int existingProductIndex =
        _products.indexWhere((element) => element.id == productId);
    ProductProvider existingProduct = _products[existingProductIndex];

    _products.removeAt(existingProductIndex);
    notifyListeners();

    final response = await http.delete(url);
    // handling exception can't be with try catch (delete fail)
    if (response.statusCode >= 400) {
      // rollback
      _products.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Deleting failed!');
    }
    existingProduct = null;
  }
}
