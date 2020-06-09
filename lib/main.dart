import 'package:flutter/material.dart';
import 'package:shop_app/helpers/custom_page_transition_builder.dart';
import 'package:shop_app/providers/auth_provider.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/providers/orders_provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/user_products_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (buildContext) => CartProvider()),
        ChangeNotifierProvider(create: (buildContext) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, ProductProvider>(
          update: (buildContext, authProvider, productProvider) {
            productProvider.updateToken(authProvider.token);
            productProvider.updateUserId(authProvider.userId);
            return productProvider;
          },
          create: (buildContext) => ProductProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, OrdersProvider>(
          update: (buildContext, authProvider, ordersProvider) {
            ordersProvider.updateToken(authProvider.token);
            ordersProvider.updateUserId(authProvider.userId);
            return ordersProvider;
          },
          create: (buildContext) => OrdersProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android: CustomPageTransitionBuilder(),
              TargetPlatform.iOS: CustomPageTransitionBuilder(),
            })),
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, child) => authProvider.isAuth
              ? ProductsOverviewScreen()
              : FutureBuilder(
                  future: authProvider.tryAutoLogin(),
                  builder: (context, snapShot) {
                    if (snapShot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return AuthScreen();
                    }
                  },
                ),
        ),
        routes: {
          ProductDetailScreen.route: (context) => ProductDetailScreen(),
          CartScreen.route: (context) => CartScreen(),
          OrdersScreen.route: (context) => OrdersScreen(),
          UserProductsScreen.route: (context) => UserProductsScreen(),
          EditProductScreen.route: (context) => EditProductScreen(),
        },
      ),
    );
  }
}
