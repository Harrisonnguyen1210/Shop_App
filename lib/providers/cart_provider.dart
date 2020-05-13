import 'package:flutter/material.dart';

class ItemCart {
  final String id;
  final String title;
  final int quantity;
  final double price;

  ItemCart({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class CartProvider with ChangeNotifier {
  Map<String, ItemCart> _items = {};

  Map<String, ItemCart> get items {
    return {..._items};
  }

  int get itemsCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (value) => ItemCart(
          id: value.id,
          title: value.title,
          price: value.price,
          quantity: value.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => ItemCart(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}
