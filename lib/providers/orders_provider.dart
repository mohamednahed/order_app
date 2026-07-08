import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:order_app/models/order.dart';
import 'package:order_app/services/local_storage.dart';

class OrdersProvider extends ChangeNotifier {
  List<Order> _orders = [];
  String _selectedFilter = 'All';
  bool _isLoading = false;
  String? _errorMessage;
  StreamSubscription<fb.User?>? _authSubscription;

  List<Order> get orders => _orders;
  String get selectedFilter => _selectedFilter;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<Order> get filteredOrders {
    if (_selectedFilter == 'All') return _orders;
    return _orders.where((o) => o.status == _selectedFilter).toList();
  }

  int get activeOrderCount => _orders
      .where((o) => o.status == 'Pending' || o.status == 'Preparing')
      .length;

  OrdersProvider() {
    _authSubscription = fb.FirebaseAuth.instance.authStateChanges().listen((_) {
      _loadOrdersForCurrentUser();
    });
    _loadOrdersForCurrentUser();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  String? _getCurrentUserId() {
    final authUser = fb.FirebaseAuth.instance.currentUser;
    if (authUser?.uid != null && authUser!.uid.isNotEmpty) {
      return authUser.uid;
    }

    return LocalStorage.getUser()?.id;
  }

  Future<void> _loadOrdersForCurrentUser() async {
    final userId = _getCurrentUserId();
    if (userId == null || userId.isEmpty) {
      _orders = [];
      _errorMessage = 'Please login to view your orders.';
      notifyListeners();
      return;
    }

    await fetchOrders(userId);
  }

  Future<void> fetchOrders(String userId) async {
    _errorMessage = null;
    _setLoading(true);

    try {
      final snapshot = await firestore.FirebaseFirestore.instance
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .get();

      final orders = snapshot.docs
          .map((doc) => Order.fromMap(doc.data(), doc.id))
          .toList();

      orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      _orders = orders;
    } catch (error) {
      _errorMessage = 'Failed to load orders. Please try again.';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addOrder(Order order, String userId) async {
    _errorMessage = null;
    _setLoading(true);

    try {
      await firestore.FirebaseFirestore.instance
          .collection('orders')
          .doc(order.id)
          .set(order.toMap(userId));
      _orders.insert(0, order);
    } catch (error) {
      _errorMessage = 'Unable to add order. Please try again.';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateOrder(Order updatedOrder) async {
    _errorMessage = null;
    _setLoading(true);

    try {
      final userId = _getCurrentUserId() ?? '';
      await firestore.FirebaseFirestore.instance
          .collection('orders')
          .doc(updatedOrder.id)
          .update(updatedOrder.toMap(userId));

      final index = _orders.indexWhere((o) => o.id == updatedOrder.id);
      if (index != -1) {
        _orders[index] = updatedOrder;
      }
    } catch (error) {
      _errorMessage = 'Unable to update order. Please try again.';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteOrder(String orderId) async {
    _errorMessage = null;
    _setLoading(true);

    try {
      await firestore.FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .delete();
      _orders.removeWhere((o) => o.id == orderId);
    } catch (error) {
      _errorMessage = 'Unable to delete order. Please try again.';
    } finally {
      _setLoading(false);
    }
  }

  void setFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }
}
