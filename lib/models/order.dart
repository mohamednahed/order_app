class Order {
  final String id;
  final String table;
  final String items;
  final double price;
  final String date;
  String status;

  Order({
    required this.id,
    required this.table,
    required this.items,
    required this.price,
    required this.date,
    required this.status,
  });
}
