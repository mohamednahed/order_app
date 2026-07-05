import 'package:flutter/material.dart';
import 'package:order_app/models/order.dart';

class OrdersProvider extends ChangeNotifier {
  List<Order> _orders = [];
  String _selectedFilter = 'All';

  List<Order> get orders => _orders;
  String get selectedFilter => _selectedFilter;

  List<Order> get filteredOrders {
    if (_selectedFilter == 'All') return _orders;
    return _orders.where((o) => o.status == _selectedFilter).toList();
  }

  int get activeOrderCount =>
      _orders.where((o) => o.status == 'Pending' || o.status == 'Preparing').length;

  OrdersProvider() {
    _orders = [
      Order(id: '1', table: 'Table 5', items: 'Pizza x2, Cola', price: 40, date: '12 May 2024 • 10:30 AM', status: 'Preparing'),
      Order(id: '2', table: 'Table 2', items: 'Burger, Fries', price: 25, date: '12 May 2024 • 10:15 AM', status: 'Ready'),
      Order(id: '3', table: 'Table 8', items: 'Pasta, Water', price: 18, date: '12 May 2024 • 09:50 AM', status: 'Delivered'),
      Order(id: '4', table: 'Table 3', items: 'Sandwich, Juice', price: 20, date: '12 May 2024 • 09:30 AM', status: 'Pending'),
    ];
  }

  void setFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  void addOrder(Order order) {
    _orders.insert(0, order);
    notifyListeners();
  }

  void updateOrder(Order updatedOrder) {
    final index = _orders.indexWhere((o) => o.id == updatedOrder.id);
    if (index != -1) {
      _orders[index] = updatedOrder;
      notifyListeners();
    }
  }

  void updateOrderStatus(String orderId, String newStatus) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      _orders[index].status = newStatus;
      notifyListeners();
    }
  }

  void deleteOrder(String orderId) {
    _orders.removeWhere((o) => o.id == orderId);
    notifyListeners();
  }
}
