import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ProductProvider with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  ProductProvider(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavourite = false});

  toggleFavourite() async {
    final url =
        'https://flutter-shop-app-3f55f.firebaseio.com/products/$id.json';
    final oldStatus = isFavourite;

    isFavourite = !isFavourite;
    notifyListeners();

    try {
      final response = await http.patch(url,
          body: json.encode({
            'isFavourite': isFavourite,
          }));
      if (response.statusCode >= 400) {
        isFavourite = oldStatus;
        notifyListeners();
      }
    } catch (e) {
      isFavourite = oldStatus;
      notifyListeners();
      print(e);
    }
  }

  @override
  String toString() {
    return 'id:$id, title:$title, description:$description, price:$price, imageUrl:$imageUrl,  isFav:$isFavourite, ';
  }
}
