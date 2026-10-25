import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/product_model.dart';

class PaymentService {
  final SupabaseClient _supabase = Supabase.instance.client;
  Future<List<Product>> fetchProducts() async {
    final response = await _supabase.from('products').select().order('name');
    return (response as List)
        .map((item) => Product.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  Future<Map<String, dynamic>> createInvoice(Map<Product, int> cart) async {
    final res = await _supabase.functions.invoke(
      'create-invoice',
      body: {
        'items': cart.entries
            .map((e) => {'product_id': e.key.id, 'quantity': e.value})
            .toList(),
      },
    );
    if (res.status < 200 || res.status >= 300 || res.data is! Map) {
      throw Exception(
        'Could not create checkout. Check the Supabase Edge Function setup.',
      );
    }
    return Map<String, dynamic>.from(res.data as Map);
  }

  Future<String> checkOrderStatus(String externalId) async {
    final rows = await _supabase
        .from('orders')
        .select('status')
        .eq('external_id', externalId)
        .limit(1);
    return rows.isEmpty
        ? 'PENDING'
        : (rows.first['status'] ?? 'PENDING').toString();
  }

  Future<List<Map<String, dynamic>>> fetchOrders() async {
    final response = await _supabase
        .from('orders')
        .select()
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }
}
