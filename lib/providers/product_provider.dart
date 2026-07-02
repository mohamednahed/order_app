import 'package:flutter/material.dart';
import 'package:order_app/models/product.dart';

class ProductProvider extends ChangeNotifier {
  final List<Product> _products = [];

  List<Product> get products => List.unmodifiable(_products);

  ProductProvider() {
    _products.addAll([
      Product(id: '1', name: 'Margherita Pizza', description: 'Classic tomato, mozzarella, basil', price: 12.99),
      Product(id: '2', name: 'Pepperoni Pizza', description: 'Pepperoni, mozzarella, tomato sauce', price: 14.99),
      Product(id: '3', name: 'Cheeseburger', description: 'Beef patty, cheddar, lettuce, tomato', price: 10.99),
      Product(id: '4', name: 'Caesar Salad', description: 'Romaine, croutons, parmesan, caesar dressing', price: 8.99),
      Product(id: '5', name: 'Pasta Carbonara', description: 'Spaghetti, bacon, egg, parmesan', price: 11.99),
      Product(id: '6', name: 'French Fries', description: 'Crispy golden fries with ketchup', price: 4.99),
      Product(id: '7', name: 'Cola', description: 'Refreshing carbonated drink', price: 2.50),
      Product(id: '8', name: 'Orange Juice', description: 'Freshly squeezed orange juice', price: 3.99),
    ]);
  }

  Product? getProductById(String id) {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Product> searchProducts(String query) {
    if (query.isEmpty) return _products;
    return _products
        .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
