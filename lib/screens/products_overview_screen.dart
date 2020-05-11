import 'package:flutter/material.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) => _menuPopupSelected(selectedValue),
            itemBuilder: (_) => [
              PopupMenuItem(
                  child: Text('Only Favourites'),
                  value: FilterOptions.Favourites),
              PopupMenuItem(child: Text('Show all'), value: FilterOptions.All),
            ],
            icon: Icon(Icons.more_vert),
          )
        ],
      ),
      body: ProductGrid(_isShowingFavourites),
    );
  }
}
