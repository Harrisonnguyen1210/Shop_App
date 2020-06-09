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

class _ItemOrderState extends State<ItemOrder>
    with SingleTickerProviderStateMixin {
  var _expanded = false;
  AnimationController _animationController;
  Animation _slideAnimation;
  Animation _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    _slideAnimation = Tween(
      begin: Offset(0, -1),
      end: Offset(0, 0),
    ).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.linear));
    _fadeAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
  }

  void _toggleExpanded() {
    setState(() {
      _expanded = !_expanded;
    });
    if (_expanded)
      _animationController.forward();
    else {
      _animationController.reverse();
    }
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
          FadeTransition(
            opacity: _fadeAnimation,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: _expanded
                  ? min(widget.orderItem.cartItems.length * 20.0 + 50, 120)
                  : 0,
              child: ListView.builder(
                itemCount: widget.orderItem.cartItems.length,
                itemBuilder: (context, index) => OrderExpanded(
                  widget.orderItem.cartItems[index],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
