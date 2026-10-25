import 'package:flutter/material.dart';

import '../services/payment_service.dart';

class OrdersScreen extends StatefulWidget {
  final bool demoMode;
  const OrdersScreen({super.key, this.demoMode = false});
  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  PaymentService? _serviceInstance;
  PaymentService get _service => _serviceInstance ??= PaymentService();
  late Future<List<Map<String, dynamic>>> _orders;
  @override
  void initState() {
    super.initState();
    _orders = widget.demoMode ? Future.value([]) : _service.fetchOrders();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Order history'),
      actions: [
        if (!widget.demoMode)
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() => _orders = _service.fetchOrders()),
          ),
      ],
    ),
    body: FutureBuilder<List<Map<String, dynamic>>>(
      future: _orders,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Unable to load orders. ${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        final orders = snapshot.data ?? [];
        if (orders.isEmpty) {
          return const Center(
            child: Text('No orders yet. Your purchases will show here.'),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: orders.length,
          separatorBuilder: (_, _) => const SizedBox(height: 8),
          itemBuilder: (context, i) {
            final order = orders[i];
            final status = (order['status'] ?? 'PENDING')
                .toString()
                .toUpperCase();
            final paid = status == 'PAID';
            final amount = num.tryParse('${order['amount'] ?? 0}') ?? 0;
            return Card(
              color: Colors.white,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: paid
                      ? Colors.green.shade50
                      : Colors.orange.shade50,
                  child: Icon(
                    paid ? Icons.check_circle : Icons.schedule,
                    color: paid
                        ? Colors.green.shade700
                        : Colors.orange.shade800,
                  ),
                ),
                title: Text(
                  order['product_name']?.toString() ?? 'SariSari order',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Text('Ref: ${order['external_id'] ?? '—'}'),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₱${amount.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      status,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: paid ? Colors.green : Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ),
  );
}
