import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

enum ProductCategory {
  food('Food'),
  toys('Toys'),
  accessories('Accessories'),
  health('Health'),
  grooming('Grooming'),
  clothing('Clothing'),
  other('Other');

  final String displayName;
  const ProductCategory(this.displayName);

  static ProductCategory fromString(String value) {
    return ProductCategory.values.firstWhere(
      (e) => e.toString() == 'ProductCategory.${value.toLowerCase()}',
      orElse: () => ProductCategory.other,
    );
  }
}

@freezed
class Product with _$Product {
  const Product._();

  const factory Product({
    required String id,
    required String name,
    required String description,
    required double price,
    @Default(0.0) double? rating,
    @Default(0) int reviewCount,
    required List<String> imageUrls,
    required ProductCategory category,
    @Default(0) int stock,
    @Default(false) bool isFeatured,
    @Default(false) bool isOnSale,
    double? salePrice,
    String? brand,
    double? weight,
    String? dimensions,
    List<String>? tags,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _Product;

  factory Product.empty() => Product(
        id: '',
        name: '',
        description: '',
        price: 0.0,
        imageUrls: const [],
        category: ProductCategory.other,
        brand: 'Pawfect Care',
        weight: null,
        dimensions: null,
        tags: const [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  // Helper methods
  bool get isInStock => stock > 0;
  bool get hasDiscount => isOnSale && salePrice != null && salePrice! < price;
  double get currentPrice => hasDiscount ? salePrice! : price;
  
  double get discountPercentage {
    if (!hasDiscount) return 0.0;
    return ((price - salePrice!) / price * 100).roundToDouble();
  }
  
  // Check if product is in stock with required quantity
  bool hasStock(int quantity) => stock >= quantity;
  
  // Get first image URL or placeholder
  String get mainImageUrl => 
      imageUrls.isNotEmpty ? imageUrls.first : 'https://via.placeholder.com/300';
      
  // Get search keywords for better search
  List<String> get searchKeywords => [
    ...name.toLowerCase().split(' '),
    ...description.toLowerCase().split(' '),
    category.displayName.toLowerCase(),
  ];
  

  
  // Convert to map for Firestore
  Map<String, dynamic> toDocument() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'rating': rating,
      'review_count': reviewCount,
      'image_urls': imageUrls,
      'category': category.toString().split('.').last,
      'stock': stock,
      'is_featured': isFeatured,
      'is_on_sale': isOnSale,
      'sale_price': salePrice,
      'search_keywords': searchKeywords,
      'created_at': Timestamp.fromDate(createdAt),
      'updated_at': Timestamp.fromDate(updatedAt),
    };
  }

  // Convert Firestore data to Product
  factory Product.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return Product.fromJson({
      ...data,
      'id': doc.id,
      'category': ProductCategory.fromString(data['category'] ?? 'other'),
      'imageUrls': data['image_urls'] ?? [],
      'reviewCount': data['review_count'] ?? 0,
      'isFeatured': data['is_featured'] ?? false,
      'isOnSale': data['is_on_sale'] ?? false,
      'salePrice': data['sale_price'],
      'createdAt': (data['created_at'] as Timestamp?)?.toDate() ?? DateTime.now(),
      'updatedAt': (data['updated_at'] as Timestamp?)?.toDate() ?? DateTime.now(),
    });
  }

  // Convert Product to Firestore data
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'rating': rating,
      'review_count': reviewCount,
      'image_urls': imageUrls,
      'category': category.toString().split('.').last,
      'stock': stock,
      'is_featured': isFeatured,
      'is_on_sale': isOnSale,
      'sale_price': salePrice,
      'brand': brand,
      'weight': weight,
      'dimensions': dimensions,
      'tags': tags,
      'search_keywords': searchKeywords,
      'created_at': Timestamp.fromDate(createdAt),
      'updated_at': Timestamp.fromDate(updatedAt),
    };
  }
}

