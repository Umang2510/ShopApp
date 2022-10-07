import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//here we have two classes of same name so we have to methos to deal with

// here dart only import the cart not CartItem
import '../providers/cart.dart' show Cart;
//import '../Widgets/cart_item.dart' as ci;
import '../Widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key key}) : super(key: key);

  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  const Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount}',
                      style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .titleLarge
                              .color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  TextButton(
                    child: Text('Order Now'),
                    onPressed: () {},
                    style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).primaryColor),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
                itemCount: cart.item.length,
                //ci.CartItem
                itemBuilder: (ctx, i) => CartItem(
                    cart.item.values.toList()[i].id,
                    cart.item.values.toList()[i].price,
                    cart.item.values.toList()[i].quantity,
                    cart.item.values.toList()[i].title)),
          )
        ],
      ),
    );
  }
}
