import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  final String id;
  final String table;
  final String items;
  final double price;
  final String date;
  String status;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.table,
    required this.items,
    required this.price,
    required this.date,
    required this.status,
    required this.createdAt,
  });

  factory Order.fromMap(Map<String, dynamic> map, String id) {
    return Order(
      id: id,
      table: map['table'] as String? ?? '',
      items: map['items'] as String? ?? '',
      price: (map['price'] is num ? (map['price'] as num).toDouble() : double.tryParse('${map['price']}') ?? 0.0),
      date: map['date'] as String? ?? '',
      status: map['status'] as String? ?? 'Pending',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap(String userId) {
    return {
      'table': table,
      'items': items,
      'price': price,
      'date': date,
      'status': status,
      'userId': userId,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  Order copyWith({
    String? table,
    String? items,
    double? price,
    String? date,
    String? status,
  }) {
    return Order(
      id: id,
      table: table ?? this.table,
      items: items ?? this.items,
      price: price ?? this.price,
      date: date ?? this.date,
      status: status ?? this.status,
      createdAt: createdAt,
    );
  }
}
