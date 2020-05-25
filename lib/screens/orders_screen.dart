import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders_provider.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/item_order.dart';

class OrdersScreen extends StatefulWidget {
  static const route = '/order';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your orders'),
      ),
      body: FutureBuilder(
        future:
            Provider.of<OrdersProvider>(context, listen: false).fetchOrders(),
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (asyncSnapshot.error != null) {
              return Center(child: Text('Error occurred'));
            } else {
              return Consumer<OrdersProvider>(
                builder: (context, ordersProvider, child) => ListView.builder(
                  itemCount: ordersProvider.orders.length,
                  itemBuilder: (context, index) =>
                      ItemOrder(ordersProvider.orders[index]),
                ),
              );
            }
          }
        },
      ),
      drawer: AppDrawer(),
    );
  }
}
