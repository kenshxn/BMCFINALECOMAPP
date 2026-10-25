import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/product_model.dart';
import '../services/payment_service.dart';
import 'orders_screen.dart';
import 'xendit_webview_screen.dart';

const _green = Color(0xFF155B45);
const _categories = [
  'All',
  'Snacks',
  'Drinks',
  'Pantry',
  'Personal care',
  'Home',
];
const _demoProducts = <Product>[
  Product(
    id: '1',
    name: 'Lucky Me! Pancit Canton',
    category: 'Pantry',
    price: 17,
    imageUrl: 'https://luckyme.ph/img/products/webp/2023_0418_LuckyMe_Kalamansi_80g_Mockup_1stPass.webp',
    description: 'Calamansi instant noodles',
    isPopular: true,
  ),
  Product(
    id: '2',
    name: 'Coca-Cola 1.5 L',
    category: 'Drinks',
    price: 35,
    imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRUnH8MxgFbdwMxGjI8KxjFIgLuR66yY1f5GkZWs4u0rg&s',
    description: 'Share-size sparkling cola',
  ),
  Product(
    id: '3',
    name: 'Piattos Cheese',
    category: 'Snacks',
    price: 35,
    imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSUxrnar9WRF7nVAmKoH-pB2epcR6qL6tUAkX3P2mxT7A&s=10',
    description: 'Crunchy cheese potato crisps',
    isPopular: true,
  ),
  Product(
    id: '4',
    name: 'Fresh eggs (per piece)',
    category: 'Pantry',
    price: 10,
    imageUrl: 'https://images.unsplash.com/photo-1506976785307-8732e854ad03?auto=format&fit=crop&w=900&q=85',
    description: 'Farm fresh brown egg',
  ),
  Product(
    id: '5',
    name: 'White rice (1 kg)',
    category: 'Pantry',
    price: 58,
    imageUrl: 'https://images.unsplash.com/photo-1586201375761-83865001e31c?auto=format&fit=crop&w=900&q=85',
    description: 'Everyday premium rice',
  ),
  Product(
    id: '6',
    name: 'Gardenia Classic White',
    category: 'Pantry',
    price: 75,
    imageUrl: 'https://ever.ph/cdn/shop/files/9000000119-Gardenia-White-Bread-Classic-Loaf-400g-240129.jpg?v=1707871690',
    description: 'Soft sliced white bread',
  ),
  Product(
    id: '7',
    name: 'Fresh milk 1 L',
    category: 'Drinks',
    price: 99,
    imageUrl: 'https://images.unsplash.com/photo-1563636619-e9143da7973b?auto=format&fit=crop&w=900&q=85',
    description: 'Chilled creamy fresh milk',
  ),
  Product(
    id: '8',
    name: 'Mango juice 1 L',
    category: 'Drinks',
    price: 78,
    imageUrl: 'https://images.unsplash.com/photo-1600271886742-f049cd451bba?auto=format&fit=crop&w=900&q=85',
    description: 'Tropical mango fruit drink',
  ),
  Product(
    id: '9',
    name: 'Banana chips',
    category: 'Snacks',
    price: 35,
    imageUrl: 'https://images.unsplash.com/photo-1603833665858-e61d17a86224?auto=format&fit=crop&w=900&q=85',
    description: 'Crispy sweet banana chips',
  ),
  Product(
    id: '10',
    name: 'Potato chips',
    category: 'Snacks',
    price: 25,
    imageUrl: 'https://images.unsplash.com/photo-1566478989037-eec170784d0b?auto=format&fit=crop&w=900&q=85',
    description: 'Classic salted crunchy chips',
  ),
  Product(
    id: '11',
    name: 'Instant coffee sachet',
    category: 'Drinks',
    price: 12,
    imageUrl: 'https://images.unsplash.com/photo-1517701550927-30cf4ba1dba5?auto=format&fit=crop&w=900&q=85',
    description: 'Rich instant coffee, single serve',
  ),
  Product(
    id: '12',
    name: 'Bottled water 1 L',
    category: 'Drinks',
    price: 25,
    imageUrl: 'https://images.unsplash.com/photo-1523362628745-0c100150b504?auto=format&fit=crop&w=900&q=85',
    description: 'Refreshing purified drinking water',
  ),
  Product(
    id: '13',
    name: 'Canned sardines',
    category: 'Pantry',
    price: 28,
    imageUrl: 'https://images.unsplash.com/photo-1584269600464-37b1b58a9fe7?auto=format&fit=crop&w=900&q=85',
    description: 'Tomato sauce sardines',
  ),
  Product(
    id: '14',
    name: 'Corned beef can',
    category: 'Pantry',
    price: 48,
    imageUrl: 'https://images.unsplash.com/photo-1584269600464-37b1b58a9fe7?auto=format&fit=crop&w=900&q=85',
    description: 'Savory beef, ready to eat',
  ),
  Product(
    id: '15',
    name: 'Bath soap bar',
    category: 'Personal care',
    price: 35,
    imageUrl: 'https://images.unsplash.com/photo-1600857544200-b2f666a9a2ec?auto=format&fit=crop&w=900&q=85',
    description: 'Gentle everyday cleansing bar',
  ),
  Product(
    id: '16',
    name: 'Shampoo sachet',
    category: 'Personal care',
    price: 8,
    imageUrl: 'https://images.unsplash.com/photo-1608248543803-ba4f8c70ae0b?auto=format&fit=crop&w=900&q=85',
    description: 'Fresh clean single-use sachet',
  ),
  Product(
    id: '17',
    name: 'Toothpaste',
    category: 'Personal care',
    price: 42,
    imageUrl: 'https://images.unsplash.com/photo-1609840114035-3c981b782dfe?auto=format&fit=crop&w=900&q=85',
    description: 'Family size mint toothpaste',
  ),
  Product(
    id: '18',
    name: 'Laundry detergent sachet',
    category: 'Home',
    price: 12,
    imageUrl: 'https://images.unsplash.com/photo-1585421514284-efb74c2b69ba?auto=format&fit=crop&w=900&q=85',
    description: 'Powerful fresh laundry clean',
  ),
  Product(
    id: '19',
    name: 'Dishwashing liquid',
    category: 'Home',
    price: 45,
    imageUrl: 'https://images.unsplash.com/photo-1600857544200-b2f666a9a2ec?auto=format&fit=crop&w=900&q=85',
    description: 'Citrus clean dish soap',
  ),
  Product(
    id: '20',
    name: 'White sugar (500 g)',
    category: 'Pantry',
    price: 38,
    imageUrl: 'https://images.unsplash.com/photo-1581441363689-1f3c3c414635?auto=format&fit=crop&w=900&q=85',
    description: 'Fine granulated white sugar',
  ),
];

class ProductListScreen extends StatefulWidget {
  final bool demoMode;
  const ProductListScreen({super.key, this.demoMode = false});
  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  PaymentService? _paymentServiceInstance;
  PaymentService get _paymentService =>
      _paymentServiceInstance ??= PaymentService();
  final Map<Product, int> _cart = {};
  late Future<List<Product>> _products;
  String _category = 'All', _query = '';
  bool _checkoutBusy = false;
  @override
  void initState() {
    super.initState();
    _products = _loadProducts();
  }

  Future<List<Product>> _loadProducts() async {
    if (widget.demoMode) return _demoProducts;
    try {
      final rows = await _paymentService.fetchProducts();
      return rows.isEmpty ? _demoProducts : rows;
    } catch (_) {
      return _demoProducts;
    }
  }

  Future<void> _refresh() async {
    setState(() => _products = _loadProducts());
    await _products;
  }

  int get _cartCount => _cart.values.fold(0, (a, b) => a + b);
  double get _total => _cart.entries.fold<double>(
    0,
    (a, b) => a + b.key.price.toDouble() * b.value,
  );
  void _change(Product product, int delta) => setState(() {
    final count = (_cart[product] ?? 0) + delta;
    if (count <= 0) {
      _cart.remove(product);
    } else {
      _cart[product] = count;
    }
  });
  Future<void> _checkout() async {
    if (widget.demoMode) {
      _show(
        'Connect Supabase and deploy the Xendit Edge Function to accept payments.',
      );
      return;
    }
    setState(() => _checkoutBusy = true);
    try {
      final data = await _paymentService.createInvoice(_cart);
      final url = data['invoice_url']?.toString() ?? '';
      final id = data['external_id']?.toString() ?? '';
      if (!url.startsWith('https://') || id.isEmpty) {
        throw Exception('The checkout service returned an invalid invoice.');
      }
      if (!mounted) return;
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => XenditWebViewScreen(invoiceUrl: url)),
      );
      final status = await _paymentService.checkOrderStatus(id);
      if (!mounted) return;
      _show(
        status == 'PAID'
            ? 'Payment confirmed. Thanks for shopping local!'
            : 'Order status: $status',
      );
      if (status == 'PAID') setState(_cart.clear);
    } catch (e) {
      if (mounted) _show('Checkout failed: $e');
    } finally {
      if (mounted) setState(() => _checkoutBusy = false);
    }
  }

  void _show(String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.storefront_rounded, color: _green),
            SizedBox(width: 8),
            Text(
              'sari sari',
              style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: -.5),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Order history',
            icon: const Icon(Icons.receipt_long_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => OrdersScreen(demoMode: widget.demoMode),
              ),
            ),
          ),
          if (!widget.demoMode)
            IconButton(
              tooltip: 'Sign out',
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await Supabase.instance.client.auth.signOut();
              },
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3EEDF),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your neighborhood\nstore, delivered.',
                        style: TextStyle(
                          fontSize: 25,
                          height: 1.15,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF193C2E),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Everyday essentials, just around the corner.',
                        style: TextStyle(color: Color(0xFF52685B)),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          const Icon(
                            Icons.local_shipping_outlined,
                            color: _green,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'Fresh finds. Friendly prices.',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: _green,
                            ),
                          ),
                          const Spacer(),
                          if (widget.demoMode)
                            const Text(
                              'PREVIEW',
                              style: TextStyle(
                                fontSize: 11,
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.bold,
                                color: _green,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                TextField(
                  onChanged: (v) => setState(() => _query = v.toLowerCase()),
                  decoration: InputDecoration(
                    hintText: 'Search your essentials',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: _categories
                        .map(
                          (c) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(c),
                              selected: _category == c,
                              onSelected: (_) => setState(() => _category = c),
                              selectedColor: const Color(0xFFDCE9D8),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: FutureBuilder<List<Product>>(
                future: _products,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: _green),
                    );
                  }
                  final all = snapshot.data ?? _demoProducts;
                  final products = all
                      .where(
                        (p) =>
                            (_category == 'All' ||
                                p.category.toLowerCase() ==
                                    _category.toLowerCase()) &&
                            ('${p.name} ${p.category}'.toLowerCase().contains(
                              _query,
                            )),
                      )
                      .toList();
                  if (products.isEmpty) {
                    return ListView(
                      children: const [
                        SizedBox(height: 100),
                        Center(
                          child: Text('No items found. Try another search.'),
                        ),
                      ],
                    );
                  }
                  return GridView.builder(
                    padding: const EdgeInsets.fromLTRB(18, 12, 18, 20),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 230,
                          mainAxisExtent: 255,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                    itemCount: products.length,
                    itemBuilder: (context, i) => _ProductCard(
                      product: products[i],
                      count: _cart[products[i]] ?? 0,
                      onAdd: () => _change(products[i], 1),
                      onRemove: () => _change(products[i], -1),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _cart.isEmpty
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 12),
                child: FilledButton(
                  onPressed: _checkoutBusy
                      ? null
                      : () => showModalBottomSheet<void>(
                          context: context,
                          isScrollControlled: true,
                          showDragHandle: true,
                          builder: (_) => StatefulBuilder(
                            builder: (_, updateSheet) => _CartSheet(
                              cart: _cart,
                              total: _total,
                              busy: _checkoutBusy,
                              onAdd: (p) {
                                _change(p, 1);
                                updateSheet(() {});
                              },
                              onRemove: (p) {
                                _change(p, -1);
                                updateSheet(() {});
                              },
                              onCheckout: _checkout,
                            ),
                          ),
                        ),
                  style: FilledButton.styleFrom(
                    backgroundColor: _green,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.shopping_bag_outlined),
                      const SizedBox(width: 8),
                      Text(
                        '$_cartCount items  ·  View basket',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Text(
                        '₱${_total.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  final int count;
  final VoidCallback onAdd, onRemove;
  const _ProductCard({
    required this.product,
    required this.count,
    required this.onAdd,
    required this.onRemove,
  });
  @override
  Widget build(BuildContext context) => Card(
    clipBehavior: Clip.antiAlias,
    elevation: 0,
    color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
      side: const BorderSide(color: Color(0xFFECECE5)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  color: const Color(0xFFE8ECE5),
                  child: const Icon(
                    Icons.shopping_basket_outlined,
                    size: 45,
                    color: _green,
                  ),
                ),
              ),
              if (product.isPopular)
                const Positioned(left: 9, top: 9, child: _Tag(text: 'POPULAR')),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(11, 9, 7, 9),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                product.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 11, color: Colors.black54),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    '₱${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: _green,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  count == 0
                      ? InkWell(
                          onTap: onAdd,
                          borderRadius: BorderRadius.circular(20),
                          child: const Padding(
                            padding: EdgeInsets.all(4),
                            child: Icon(
                              Icons.add_circle,
                              color: _green,
                              size: 30,
                            ),
                          ),
                        )
                      : Row(
                          children: [
                            InkWell(
                              onTap: onRemove,
                              child: const Icon(
                                Icons.remove_circle_outline,
                                size: 25,
                                color: _green,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                              ),
                              child: Text(
                                '$count',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: onAdd,
                              child: const Icon(
                                Icons.add_circle,
                                size: 25,
                                color: _green,
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _Tag extends StatelessWidget {
  final String text;
  const _Tag({required this.text});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: const Color(0xFFE4F2DC),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 9,
        color: _green,
        fontWeight: FontWeight.w800,
        letterSpacing: .5,
      ),
    ),
  );
}

class _CartSheet extends StatelessWidget {
  final Map<Product, int> cart;
  final double total;
  final bool busy;
  final void Function(Product) onAdd, onRemove;
  final VoidCallback onCheckout;
  const _CartSheet({
    required this.cart,
    required this.total,
    required this.busy,
    required this.onAdd,
    required this.onRemove,
    required this.onCheckout,
  });
  @override
  Widget build(BuildContext context) => SafeArea(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your basket',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...cart.entries.map(
            (e) => ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(e.key.name),
              subtitle: Text('₱${e.key.price.toStringAsFixed(2)} each'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => onRemove(e.key),
                    icon: const Icon(Icons.remove_circle_outline),
                  ),
                  Text('${e.value}'),
                  IconButton(
                    onPressed: () => onAdd(e.key),
                    icon: const Icon(Icons.add_circle_outline),
                  ),
                ],
              ),
            ),
          ),
          const Divider(),
          Row(
            children: [
              const Text(
                'Total',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(
                '₱${total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  color: _green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: busy
                  ? null
                  : () {
                      Navigator.pop(context);
                      onCheckout();
                    },
              child: const Text('Continue to secure checkout'),
            ),
          ),
        ],
      ),
    ),
  );
}
