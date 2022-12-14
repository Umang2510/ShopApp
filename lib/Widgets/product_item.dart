import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Screens/product_detail_screen.dart';
import '../providers/products.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

class ProductItem extends StatelessWidget {
  //const ProductItem({Key key}) : super(key: key);
  // final String id, title, imageUrl;
  // ProductItem(this.id, this.title, this.imageUrl);

  /* we can use either provider.of or consumer, here only favorite button is actully 
  changed  when data get changed so we are using consumer there and we need data for only one time use
  so we are using provider with listen: false*/
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context,
        listen:
            false); // when use provider.of it will rebuild entire build method
    final cart = Provider.of<Cart>(context, listen: false);
    final authtoken = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          leading: Consumer<Product>(
            //only rebuild the part of widget tree like here only child will rebuild when data get changed
            builder: (ctx, product, _ /*child*/) => IconButton(
              icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border),
              onPressed: () {
                product.toggleFavoriteStatus(authtoken.token, authtoken.userId);
              },
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItem(product.id, product.price, product.title);
              //hide current scnakbar if currently on display
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              //establish a connection to the nearest Scaffold
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text('Added item to cart!'),
                duration: const Duration(seconds: 3),
                action: SnackBarAction(
                  label: 'UNDO',
                  onPressed: () {
                    cart.removeSingleItem(product.id);
                  },
                ),
              ));
            },
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                arguments: product.id);
          },
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder:
                  const AssetImage('assets/images/product-placeholder.png'),
              image: NetworkImage(product.imageURL),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
