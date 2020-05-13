import 'package:flutter/material.dart';
import 'package:shop_app/providers/cart_provider.dart';

class OrderExpanded extends StatelessWidget {
  final ItemCart itemCart;

  OrderExpanded(this.itemCart);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            itemCart.title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            '${itemCart.quantity} x \$${itemCart.price}',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
