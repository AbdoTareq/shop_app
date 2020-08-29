import 'package:flutter/foundation.dart';

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

  toggleFavourite() {
    isFavourite = !isFavourite;
    notifyListeners();
  }

  @override
  String toString() {
    return 'id:$id, title:$title, description:$description, price:$price, imageUrl:$imageUrl,  isFav:$isFavourite, ';
  }
}
