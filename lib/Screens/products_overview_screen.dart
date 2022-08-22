import 'package:flutter/material.dart';

import '../Widgets/product_grid.dart';

class ProductsOverviewScreen extends StatelessWidget {
  //const ProductsOverview({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
      ),
      body: const ProductsGrid(),
    );
  }
}
