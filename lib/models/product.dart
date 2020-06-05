import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavourite = false,
  });

  Future<void> toggleFavouriteStatus(String token, String userId) async {
    final url =
        'https://shop-app-e767d.firebaseio.com/userFavourites/$userId/$id.json?auth=$token';
    final oldStatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    final response = await http.put(
      url,
      body: json.encode(isFavourite),
    );
    if (response.statusCode >= 400) {
      isFavourite = oldStatus;
      notifyListeners();
      throw HttpException('Cannot update favourite status');
    }
  }
}
