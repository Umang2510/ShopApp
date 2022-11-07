import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageURL;
  bool isFavorite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageURL,
      this.isFavorite = false});

  Future<void> toggleFavoriteStatus(String token) async {
    var param = {
      'auth': token,
    };
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = Uri.https(
        'shopapp-5381c-default-rtdb.asia-southeast1.firebasedatabase.app',
        '/products/$id.json', param);
    try {
      final response = await http.patch(url,
          body: json.encode({
            'isFavorite': isFavorite,
          }));
      if (response.statusCode >= 400) {
        isFavorite = oldStatus;
        notifyListeners();
      }
    } catch (error) {
      isFavorite = oldStatus;
      notifyListeners();
    }
  }
}
