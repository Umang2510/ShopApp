import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Screens/products_overview_screen.dart';
import 'Screens/product_detail_screen.dart';
import 'providers/products_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //using the Provider above level of child
    return ChangeNotifierProvider(
      // provided by Provider package
      //only child which listening this will rebuild
      create: (context) =>
          ProductsProvider(), // return new instance of provided class
      child: MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.orange,
          fontFamily: 'Lato',
        ),
        home: ProductsOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
        },
      ),
    );
  }
}
