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

  Future<void> toggleFavourite(String token, String userId) async {
    final url =
        'https://flutter-shop-app-3f55f.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';
    final oldStatus = isFavourite;

    isFavourite = !isFavourite;
    notifyListeners();

    try {
      final response = await http.put(url,
          body: json.encode(
            isFavourite,
          ));
      if (response.statusCode >= 400) {
        isFavourite = oldStatus;
        notifyListeners();
      }
    } catch (e) {
      isFavourite = oldStatus;
      notifyListeners();
      print('dart mess: $e');
    }
  }

  @override
  String toString() {
    return 'id:$id, title:$title, description:$description, price:$price, imageUrl:$imageUrl,  isFav:$isFavourite, ';
  }
}
