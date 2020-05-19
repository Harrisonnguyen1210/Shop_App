import 'package:flutter/material.dart';
import 'package:shop_app/models/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductProvider with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favouriteItems {
    return _items.where((item) => item.isFavourite).toList();
  }

  Future<void> addProduct(Product product) async {
    const url = 'https://shop-app-e767d.firebaseio.com/products.json';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'isFavourite': product.isFavourite
        }),
      );
      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          price: product.price,
          description: product.description,
          imageUrl: product.imageUrl);
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Product findById(String productId) {
    return _items.firstWhere((product) => product.id == productId);
  }

  void updateProduct(Product newProduct) {
    _items[_items.indexWhere((element) => newProduct.id == element.id)] =
        newProduct;
    notifyListeners();
  }

  void deleteProduct(String productId) {
    _items.removeWhere((element) => element.id == productId);
    notifyListeners();
  }

  Future<void> fetchProducts() async {
    const url = 'https://shop-app-e767d.firebaseio.com/products.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> productList = [];
      extractedData.forEach((key, value) {
        productList.add(Product(
          id: key,
          title: value['title'],
          description: value['description'],
          price: value['price'],
          imageUrl: value['imageUrl'],
          isFavourite: value['isFavourite'],
        ));
      });
      _items = productList;
      print(json.decode(response.body));
    } catch (error) {
      throw error;
    }
  }
}
