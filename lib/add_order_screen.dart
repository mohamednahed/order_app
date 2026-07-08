import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/order.dart';
import 'providers/orders_provider.dart';
import 'services/local_storage.dart';

class AddOrderScreen extends StatefulWidget {
  final Order? order;

  const AddOrderScreen({super.key, this.order});

  @override
  State<AddOrderScreen> createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends State<AddOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tableController = TextEditingController();
  final _customerController = TextEditingController();
  final _itemsController = TextEditingController();
  final _priceController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _selectedStatus = 'Pending';

  bool get _isEditing => widget.order != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final order = widget.order!;
      _tableController.text = order.table;
      _priceController.text = order.price.toString();
      _selectedStatus = order.status;
      _selectedDate = _parseDate(order.date);

      final parts = order.items.split(' • ');
      if (parts.length >= 2) {
        _itemsController.text = parts.first;
        _customerController.text = parts[1];
      } else {
        _itemsController.text = order.items;
      }
    }
  }

  @override
  void dispose() {
    _tableController.dispose();
    _customerController.dispose();
    _itemsController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2035),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  DateTime _parseDate(String value) {
    final cleanValue = value.split(' • ').first;
    final slashParts = cleanValue.split('/');
    if (slashParts.length == 3) {
      final day = int.tryParse(slashParts[0]) ?? DateTime.now().day;
      final month = int.tryParse(slashParts[1]) ?? DateTime.now().month;
      final year = int.tryParse(slashParts[2]) ?? DateTime.now().year;
      return DateTime(year, month, day);
    }

    final spaceParts = cleanValue.split(' ');
    if (spaceParts.length >= 3) {
      final day = int.tryParse(spaceParts[0]) ?? DateTime.now().day;
      final month = _monthNameToNumber(spaceParts[1]);
      final year = int.tryParse(spaceParts[2]) ?? DateTime.now().year;
      return DateTime(year, month, day);
    }

    return DateTime.now();
  }

  int _monthNameToNumber(String monthName) {
    switch (monthName.toLowerCase()) {
      case 'jan':
      case 'january':
        return 1;
      case 'feb':
      case 'february':
        return 2;
      case 'mar':
      case 'march':
        return 3;
      case 'apr':
      case 'april':
        return 4;
      case 'may':
        return 5;
      case 'jun':
      case 'june':
        return 6;
      case 'jul':
      case 'july':
        return 7;
      case 'aug':
      case 'august':
        return 8;
      case 'sep':
      case 'sept':
      case 'september':
        return 9;
      case 'oct':
      case 'october':
        return 10;
      case 'nov':
      case 'november':
        return 11;
      case 'dec':
      case 'december':
        return 12;
      default:
        return DateTime.now().month;
    }
  }

  Future<void> _submitOrder() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final price = double.tryParse(_priceController.text.trim()) ?? 0.0;
    final order = Order(
      id: _isEditing ? widget.order!.id : DateTime.now().microsecondsSinceEpoch.toString(),
      table: _tableController.text.trim(),
      items: '${_itemsController.text.trim()} • ${_customerController.text.trim()}',
      price: price,
      date: _formatDate(_selectedDate),
      status: _selectedStatus,
      createdAt: widget.order?.createdAt ?? DateTime.now(),
    );

    final ordersProvider = context.read<OrdersProvider>();
    final user = LocalStorage.getUser();

    if (_isEditing) {
      await ordersProvider.updateOrder(order);
    } else {
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please login first.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      await ordersProvider.addOrder(order, user.id);
    }

    if (!mounted) return;

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isEditing ? 'Order updated' : 'Order added'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Order' : 'Add New Order'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _tableController,
                decoration: const InputDecoration(
                  labelText: 'Table No.',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.table_restaurant),
                ),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Please enter the table number' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _customerController,
                decoration: const InputDecoration(
                  labelText: 'Customer Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Please enter the customer name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _itemsController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Order Details',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.restaurant_menu),
                ),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Please enter the order details' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter the price';
                  }
                  return double.tryParse(value) == null ? 'Enter Valid Price' : null;
                },
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(_formatDate(_selectedDate)),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedStatus,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.flag),
                ),
                items: const [
                  DropdownMenuItem(value: 'Pending', child: Text('Pending')),
                  DropdownMenuItem(value: 'Preparing', child: Text('Preparing')),
                  DropdownMenuItem(value: 'Ready', child: Text('Ready')),
                  DropdownMenuItem(value: 'Delivered', child: Text('Delivered')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedStatus = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _submitOrder,
                icon: Icon(_isEditing ? Icons.save_outlined : Icons.add_circle_outline),
                label: Text(_isEditing ? 'Save Changes' : 'Add Order'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
