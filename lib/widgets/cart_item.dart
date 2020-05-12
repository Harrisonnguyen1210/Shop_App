import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart_provider.dart';

class CartItem extends StatelessWidget {
  final MapEntry<String, ItemCart> itemCart;

  CartItem(this.itemCart);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<CartProvider>(context, listen: false).removeItem(itemCart.key);
      },
      background: Container(
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(color: Colors.red),
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 30,
        ),
      ),
      key: ValueKey(itemCart.key),
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: FittedBox(
                  child: Text('\$${itemCart.value.price}'),
                ),
              ),
            ),
            title: Text(itemCart.value.title),
            subtitle: Text(
              'Total: \$${itemCart.value.price * itemCart.value.quantity}',
            ),
            trailing: Text(
              itemCart.value.quantity.toString(),
            ),
          ),
        ),
      ),
    );
  }
}
