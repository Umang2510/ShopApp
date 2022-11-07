import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;

import 'products.dart';
import '../models/http_exception.dart';

// Mixin - keyword 'with'- this does not inherit or create instence of inherited class but add the features of that class or we can say inheritance lite.
class ProductsProvider with ChangeNotifier {
  List<Product> _items = [
    //   Product(
    //     id: 'p1',
    //     title: 'Red Shirt',
    //     description: 'A red shirt - it is pretty red!',
    //     price: 29.99,
    //     imageURL:
    //         'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    //   ),
    //   Product(
    //     id: 'p2',
    //     title: 'Trousers',
    //     description: 'A nice pair of trousers.',
    //     price: 59.99,
    //     imageURL:
    //         'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    //   ),
    //   Product(
    //     id: 'p3',
    //     title: 'Yellow Scarf',
    //     description: 'Warm and cozy - exactly what you need for the winter.',
    //     price: 19.99,
    //     imageURL:
    //         'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    //   ),
    //   Product(
    //     id: 'p4',
    //     title: 'A Pan',
    //     description: 'Prepare any meal you want.',
    //     price: 49.99,
    //     imageURL:
    //         'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    //   ),
  ];
  final String authToken;
  ProductsProvider(this.authToken, this._items);

  var _showFavoritesOnly = false;
  //this will only return one element from the list so whole list of item don't get edited
  //... spread operator level up the item from list
  List<Product> get items {
    // if (_showFavoritesOnly) {
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // } else {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findByID(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  Future<void> fetchAndSetProducts() async {
    var param = {
      'auth': authToken,
    };
    final url = Uri.https(
        'shopapp-5381c-default-rtdb.asia-southeast1.firebasedatabase.app',
        '/products.json',
        param);
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          isFavorite: prodData['isFavorite'],
          imageURL: prodData['imageUrl'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addProduct(Product localProduct) async {
    var param = {
      'auth': authToken,
    };
    //wrap the all code in Future
    final url = Uri.https(
        'shopapp-5381c-default-rtdb.asia-southeast1.firebasedatabase.app',
        '/products.json',
        param);
    //Future
    // here then() is provided by future then executes a code when certain action is done
    //return No need to return because now it will automatically retrun future
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': localProduct.title,
            'description': localProduct.description,
            'price': localProduct.price,
            'id': localProduct.id,
            'imageUrl': localProduct.imageURL,
            'isFavorite': localProduct.isFavorite,
          }));
      //then() returns a new Future so we can also add another then()
      //e.g. then().then()
      //.then((response) {
      //executes when response is available
      //print(json.decode(response.body));
      //this concept is called chaining
      //Future can also return a error so you can use catchError
      // then().catchError((error) => )
      //catchError also return error so you can add then() after catchError

      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: localProduct.title,
          description: localProduct.description,
          price: localProduct.price,
          imageURL: localProduct.imageURL);
      _items.add(newProduct);
      /*let widget know about the update we did or notify that somthing has change in data
    widgets which are listening to this class are then rebuilt and get the latest data*/
      notifyListeners();
    } catch (error) {
      print(error);
      rethrow;
    }
  } //).catchError((error) {
  //print(error);
  //throw error;
  // });
  //}

  void updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);

    if (prodIndex >= 0) {
      final url = Uri.https(
        'shopapp-5381c-default-rtdb.asia-southeast1.firebasedatabase.app',
        '/products/$id.json',
      );
      http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
            'imageUrl': newProduct.imageURL,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.https(
      'shopapp-5381c-default-rtdb.asia-southeast1.firebasedatabase.app',
      '/products/$id.json',
    );
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw Exception('Could not delete product.');
    }
    existingProduct = null;
  }
}
