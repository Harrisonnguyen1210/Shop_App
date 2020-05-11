import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final product = Provider.of<Product>(context);

    return Consumer<Product>(
      builder: (context, product, child) => ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GestureDetector(
          onTap: () => Navigator.pushNamed(context, ProductDetailScreen.route,
              arguments: product.id),
          child: GridTile(
            child: Image(
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
            ),
            footer: GridTileBar(
              leading: IconButton(
                icon: Icon(Icons.favorite),
                onPressed: () {
                  product.toggleFavouriteStatus();
                },
                color: product.isFavourite
                    ? Theme.of(context).accentColor
                    : Colors.white,
              ),
              trailing: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {},
                color: Theme.of(context).accentColor,
              ),
              title: Text(
                product.title,
                textAlign: TextAlign.center,
              ),
              backgroundColor: Colors.black54,
            ),
          ),
        ),
      ),
    );
  }
}
