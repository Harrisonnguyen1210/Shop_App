import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const route = '/user_products';

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(icon: const Icon(Icons.add), onPressed: () {
            Navigator.pushNamed(context, EditProductScreen.route);
          })
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: productProvider.items.length,
          itemBuilder: (context, index) =>
              UserProductItem(productProvider.items[index]),
        ),
      ),
      drawer: AppDrawer(),
    );
  }
}
