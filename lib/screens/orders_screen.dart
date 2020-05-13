import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders_provider.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/item_order.dart';

class OrdersScreen extends StatelessWidget {
  static const route = '/order';

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<OrdersProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your orders'),
      ),
      body: ListView.builder(
        itemCount: ordersProvider.orders.length,
        itemBuilder: (context, index) =>
            ItemOrder(ordersProvider.orders[index]),
      ),
      drawer: AppDrawer(),
    );
  }
}
