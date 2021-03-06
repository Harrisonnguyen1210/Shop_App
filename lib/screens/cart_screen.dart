import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/providers/orders_provider.dart';
import 'package:shop_app/widgets/cart_item.dart';

class CartScreen extends StatefulWidget {
  static const route = '/cart';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var _isLoading = false;

  void _addOrder(CartProvider cartProvider) async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<OrdersProvider>(context, listen: false)
        .addOrder(cartProvider.items.values.toList(), cartProvider.totalAmount);
    cartProvider.clearCart();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cartProvider.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color:
                            Theme.of(context).primaryTextTheme.headline6.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  FlatButton(
                    onPressed: (cartProvider.totalAmount <= 0 || _isLoading)
                        ? null
                        : () => _addOrder(cartProvider),
                    child: _isLoading ? CircularProgressIndicator() : Text('ORDER NOW'),
                    textColor: Theme.of(context).primaryColor,
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: cartProvider.itemsCount,
              itemBuilder: (buildContext, index) =>
                  CartItem(cartProvider.items.entries.toList()[index]),
            ),
          ),
        ],
      ),
    );
  }
}
