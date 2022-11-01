import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Widgets/product_grid.dart';
import '../Widgets/badge.dart';
import '../providers/cart.dart';
import 'cart_screen.dart';
import '../Widgets/app_drawer.dart';
import '../providers/products_provider.dart';

enum filterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  //const ProductsOverview({Key key}) : super(key: key);

  var _showOnlyFavorites = false;
  var _isInit = true;

  @override
  void initState() {
    super.initState();
    // Future.delayed(Duration(seconds: 0)).then(
    //     (_) => Provider.of<ProductsProvider>(context).fecthAndSetProduct());
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<ProductsProvider>(context).fecthAndSetProduct();
    }

    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (filterOptions selectedValue) {
              setState(() {
                if (selectedValue == filterOptions.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: const Icon(Icons.more_vert),
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: filterOptions.Favorites,
                child: Text('Only Favorites'),
              ),
              PopupMenuItem(
                value: filterOptions.All,
                child: Text('Show All'),
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: ProductsGrid(_showOnlyFavorites),
    );
  }
}
