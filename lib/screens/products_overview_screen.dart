import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/badge.dart';
import 'package:shop_app/widgets/product_grid.dart';

enum FilterOptions {
  Favourites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _isShowingFavourites = false;
  var _isLoading = false;

  void _menuPopupSelected(FilterOptions selectedValue) {
    setState(() {
      if (selectedValue == FilterOptions.Favourites) {
        _isShowingFavourites = true;
      } else {
        _isShowingFavourites = false;
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('CAll meeeeeeee');
    setState(() {
      _isLoading = true;
    });
    Provider.of<ProductProvider>(context, listen: false)
        .fetchProducts()
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) =>
                _menuPopupSelected(selectedValue),
            itemBuilder: (_) => [
              PopupMenuItem(
                  child: Text('Only Favourites'),
                  value: FilterOptions.Favourites),
              PopupMenuItem(child: Text('Show all'), value: FilterOptions.All),
            ],
            icon: Icon(Icons.more_vert),
          ),
          Consumer<CartProvider>(
            builder: (context, cartProvider, child) => Badge(
              child: child,
              value: cartProvider.itemsCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.route);
              },
            ),
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(_isShowingFavourites),
      drawer: AppDrawer(),
    );
  }
}
