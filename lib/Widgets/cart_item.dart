import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  //const CartItem({Key key}) : super(key: key);
  final String id, productId;
  final double price;
  final int quantity;
  final String title;

  CartItem(this.id, this.productId, this.price, this.quantity, this.title);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removItem(productId);
      },
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const <Widget>[
                Icon(Icons.info),
                SizedBox(width: 10),
                Text('Are you sure?'),
              ],
            ),
            content:
                const Text('Do you want to remove the item from the cart?'),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(true);
                  },
                  child: const Text(
                    'YES',
                    style: TextStyle(color: Colors.red),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(false);
                  },
                  child:
                      const Text('NO', style: TextStyle(color: Colors.green))),
            ],
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: FittedBox(
                      child: Text(
                    '\$$price',
                    style: const TextStyle(color: Colors.white),
                  ))),
            ),
            title: Text(title),
            subtitle: Text('Total:\$${(price * quantity)}'),
            trailing: Text('${quantity}x'),
          ),
        ),
      ),
    );
  }
}
