import 'package:equatable/equatable.dart';

enum ProductCategory { food, grooming, toys, health, accessories, other }

class Product extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final double rating;
  final List<String> imageUrls;
  final ProductCategory category;
  final int stock;
  final String brand;
  final double weight;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? externalUrl;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.rating,
    required this.imageUrls,
    required this.category,
    required this.stock,
    required this.brand,
    required this.weight,
    required this.createdAt,
    required this.updatedAt,
    this.externalUrl,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    price,
    rating,
    imageUrls,
    category,
    stock,
    brand,
    weight,
    createdAt,
    updatedAt,
    externalUrl,
  ];

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? rating,
    List<String>? imageUrls,
    ProductCategory? category,
    int? stock,
    String? brand,
    double? weight,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? externalUrl,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      imageUrls: imageUrls ?? this.imageUrls,
      category: category ?? this.category,
      stock: stock ?? this.stock,
      brand: brand ?? this.brand,
      weight: weight ?? this.weight,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      externalUrl: externalUrl ?? this.externalUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'rating': rating,
      'imageUrls': imageUrls,
      'category': category.name,
      'stock': stock,
      'brand': brand,
      'weight': weight,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'externalUrl': externalUrl,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      imageUrls: List<String>.from(json['imageUrls'] as List),
      category: ProductCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => ProductCategory.other,
      ),
      stock: json['stock'] as int,
      brand: json['brand'] as String,
      weight: (json['weight'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      externalUrl: json['externalUrl'] as String?,
    );
  }
}
