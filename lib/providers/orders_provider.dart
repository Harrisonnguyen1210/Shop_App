import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<ItemCart> cartItems;
  final DateTime dateTime;

  OrderItem(
      {@required this.id,
      @required this.amount,
      @required this.cartItems,
      @required this.dateTime});
}

class OrdersProvider with ChangeNotifier {
  var _token;

  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  void updateToken(String token) {
    _token = token;
  }

  Future<void> addOrder(List<ItemCart> cartItems, double total) async {
    final url = 'https://shop-app-e767d.firebaseio.com/orders.json?auth=$_token';
    final timestamp = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'cartItems': cartItems
              .map((cartItem) => {
                    'id': cartItem.id,
                    'title': cartItem.title,
                    'price': cartItem.price,
                    'quantity': cartItem.quantity
                  })
              .toList(),
          'dateTime': timestamp.toIso8601String()
        }));
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        cartItems: cartItems,
        dateTime: timestamp,
      ),
    );
    notifyListeners();
  }

  Future<void> fetchOrders() async {
    final url = 'https://shop-app-e767d.firebaseio.com/orders.json?auth=$_token';
    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedOrders = json.decode(response.body) as Map<String, dynamic>;
    if (extractedOrders == null) {
      _orders = loadedOrders;
      notifyListeners();
      return;
    }
    extractedOrders.forEach((key, value) {
      loadedOrders.insert(
          0,
          OrderItem(
              id: key,
              amount: value['amount'],
              cartItems: (value['cartItems'] as List<dynamic>)
                  .map((cartItem) => ItemCart(
                      id: cartItem['id'],
                      title: cartItem['title'],
                      quantity: cartItem['quantity'],
                      price: cartItem['price']))
                  .toList(),
              dateTime: DateTime.parse(value['dateTime'])));
    });
    _orders = loadedOrders;
    notifyListeners();
  }
}
