import 'package:flutter/material.dart';
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/models/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductProvider with ChangeNotifier {
  var _authToken;
  var _userId;

  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favouriteItems {
    return _items.where((item) => item.isFavourite).toList();
  }

  void updateToken(String token) {
    _authToken = token;
  }

  void updateUserId(String userId) {
    _userId = userId;
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://shop-app-e767d.firebaseio.com/products.json?auth=$_authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'userId': _userId
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

  Future<void> updateProduct(Product newProduct) async {
    final url =
        'https://shop-app-e767d.firebaseio.com/products/${newProduct.id}.json?auth=$_authToken';
    await http.patch(url,
        body: json.encode({
          'title': newProduct.title,
          'description': newProduct.description,
          'imageUrl': newProduct.imageUrl,
          'price': newProduct.price,
        }));
    await fetchProducts();
  }

  Future<void> deleteProduct(String productId) async {
    final url =
        'https://shop-app-e767d.firebaseio.com/products/${productId}.json?auth=$_authToken';
    final existingProductIndex =
        _items.indexWhere((product) => productId == product.id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product');
    }
    existingProduct = null;
  }

  Future<void> fetchProducts({filterByUser = false}) async {
    final filterUrlSegment = filterByUser ? 'orderBy="userId"&equalTo="$_userId"' : '';
    final url =
        'https://shop-app-e767d.firebaseio.com/products.json?auth=$_authToken&$filterUrlSegment';
    final favouriteUrl =
        'https://shop-app-e767d.firebaseio.com/userFavourites/$_userId.json?auth=$_authToken';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> productList = [];
      if (extractedData == null) {
        _items = productList;
        notifyListeners();
        return;
      }
      final favouriteResponse = await http.get(favouriteUrl);
      final favouriteData = json.decode(favouriteResponse.body);
      extractedData.forEach((key, value) {
        productList.add(Product(
          id: key,
          title: value['title'],
          description: value['description'],
          price: value['price'],
          imageUrl: value['imageUrl'],
          isFavourite: favouriteData == null ? false : favouriteData[key] ?? false,
        ));
      });
      _items = productList;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
