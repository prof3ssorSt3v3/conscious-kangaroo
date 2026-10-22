//Data Model Class for Product
// import 'dart:convert';

//Data Model class that defines the properties of a product
class Product {
  final int id;
  final String title;
  final String description;
  final double price;
  final String brand;
  final String sku;
  final String? thumbnail;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.brand,
    required this.sku,
    required this.thumbnail,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] as double,
      brand: json['brand'] ?? '',
      sku: json['sku'] ?? '',
      thumbnail: json['thumbnail'] ?? null,
    );
  }

  @override
  String toString() {
    return 'Product ${id.toString()}:  $title';
  }
}
