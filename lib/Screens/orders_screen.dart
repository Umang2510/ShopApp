import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Widgets/app_drawer.dart';
import '../providers/orders.dart' show Orders;
import '../Widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';
  const OrdersScreen({Key key}) : super(key: key);

//   @override
//   State<OrdersScreen> createState() => _OrdersScreenState();
// }

// class _OrdersScreenState extends State<OrdersScreen> {

  /// only do if you are calling build method to change somthing on scree
  /// by doing this we will not create new futures
  // Future _ordersFuture;

  // Future _obtainOrdersFuture() {
  //   return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  // }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   _ordersFuture = _obtainOrdersFuture();
  // }

  @override
  Widget build(BuildContext context) {
    //final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        //future: _ordersFuture,
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (dataSnapshot.error != null) {
              //Do error handling
            } else {
              return Consumer<Orders>(
                builder: (ctx, orderData, child) => ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
                ),
              );
            }
          }
          return const Center(child: Text('No Orders'));
        },
      ),
    );
  }
}
