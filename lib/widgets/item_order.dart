import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/providers/orders_provider.dart';
import 'package:shop_app/widgets/order_expanded.dart';

class ItemOrder extends StatefulWidget {
  final OrderItem orderItem;

  ItemOrder(this.orderItem);

  @override
  _ItemOrderState createState() => _ItemOrderState();
}

class _ItemOrderState extends State<ItemOrder> {
  var _expanded = false;

  void _toggleExpanded() {
    setState(() {
      _expanded = !_expanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('\$${widget.orderItem.amount}'),
            subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(widget.orderItem.dateTime),
            ),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: _toggleExpanded,
            ),
          ),
          if (_expanded)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: min(widget.orderItem.cartItems.length * 20.0 + 50, 120),
              child: ListView.builder(
                itemCount: widget.orderItem.cartItems.length,
                itemBuilder: (context, index) => OrderExpanded(
                  widget.orderItem.cartItems[index],
                ),
              ),
            )
        ],
      ),
    );
  }
}
