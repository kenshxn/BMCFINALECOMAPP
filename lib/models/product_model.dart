class Product {
  final String id;
  final String name;
  final String category;
  final num price;
  final String imageUrl;
  final String description;
  final bool isPopular;
  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.imageUrl,
    this.description = '',
    this.isPopular = false,
  });
  factory Product.fromMap(Map<String, dynamic> map) => Product(
    id: (map['id'] ?? '').toString(),
    name: (map['name'] ?? 'Unnamed item').toString(),
    category: (map['category'] ?? 'Pantry').toString(),
    price: num.tryParse('${map['price'] ?? 0}') ?? 0,
    imageUrl: (map['image_url'] ?? '').toString(),
    description: (map['description'] ?? '').toString(),
    isPopular: map['is_popular'] == true,
  );
}
