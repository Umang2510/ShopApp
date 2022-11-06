import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Screens/products_overview_screen.dart';
import 'Screens/product_detail_screen.dart';
import 'providers/products_provider.dart';
import 'providers/cart.dart';
import 'providers/orders.dart';
import 'Screens/cart_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/user_product.dart';
import 'Screens/edit_product_screen.dart';
import 'Screens/auth_screen.dart';
import 'providers/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //using the Provider above level of child
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Auth()),
        ChangeNotifierProvider(create: (context) => ProductsProvider()),
        ChangeNotifierProvider(create: (context) => Cart()),
        ChangeNotifierProvider(
          create: ((context) => Orders()),
        )
      ],

      //ChangeNotifierProvider(
      //  only child which listening this will rebuild
      //  automatically cleans data when its not required

      //ChangeNotifierProvider.value
      //  value constructor is used when our provider doesn't depend on context
      //value: ProductsProvider(),

      //  when you have to give data, object to ChangNotifier it is good to use create
      //  or in other words when you are creating a new instance it is good to use create
      //create: (context) =>
      //ProductsProvider(), //return new instance of provided class

      child: MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(color: Colors.purple),
          primaryColor: Colors.purple,
          colorScheme: Theme.of(context)
              .colorScheme
              .copyWith(secondary: Colors.deepOrange),
          fontFamily: 'Lato',
        ),
        home: AuthScreen(),
        routes: {
          ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
          CartScreen.routeName: (context) => const CartScreen(),
          OrdersScreen.routeName: (context) => const OrdersScreen(),
          UserProductScreen.routeName: (context) => const UserProductScreen(),
          EditProductScreen.routName: (context) => const EditProductScreen(),
        },
      ),
    );
  }
}
