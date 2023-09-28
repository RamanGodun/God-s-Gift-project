import 'package:flutter/material.dart';

import '../models/product_model.dart';
import 'db_methods.dart';

class ProductsProvider with ChangeNotifier {
  List<ProductModel> _items = [];
  List<ProductModel> get items {
    return [..._items];
  }

  Future<void> fetchProductsFromFirestore() async {
    _items = await DBmethods().fetchProductsFromFirestore();
    notifyListeners();
  }

  ProductModel? getProductById(String productId) {
    return items.firstWhere((product) => product.productId == productId,
        orElse: () => throw Exception('Product not found'));
  }
}
