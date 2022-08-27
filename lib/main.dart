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
      //only child which listening this will rebuild
      //automatically cleans data when its not required 

      //ChangeNotifierProvider.value
      //value constructor is used when our provider doesn't depend on context
      //value: ProductsProvider(),

      // when you have to give data, object to ChangNotifier it is good to use create
      // or in other words when you are creating a new instance it is good to use create
      create: (context) =>
          ProductsProvider(), //return new instance of provided class

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
