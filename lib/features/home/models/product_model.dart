class Review {
  final String id;
  final String userId;
  final String userName;
  final String userImage;
  final double rating;
  final String comment;
  final DateTime date;

  const Review({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userImage,
    required this.rating,
    required this.comment,
    required this.date,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      userId: json['userId'],
      userName: json['userName'],
      userImage: json['userImage'],
      rating: json['rating'].toDouble(),
      comment: json['comment'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'userName': userName,
    'userImage': userImage,
    'rating': rating,
    'comment': comment,
    'date': date.toIso8601String(),
  };
}

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final List<String> imageUrls;
  final String category;
  final int stock;
  final double rating;
  final bool isFavorite;
  final int reviewCount;
  final bool isOnSale;
  final double? originalPrice;
  final double? discountPercentage;
  final List<Review> reviews;
  final String? brand;
  final String? weight;
  final Map<String, String>? specifications;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrls,
    required this.category,
    required this.stock,
    required this.rating,
    required this.isFavorite,
    this.reviewCount = 0,
    this.isOnSale = false,
    this.originalPrice,
    this.discountPercentage,
    List<Review>? reviews,
    this.brand,
    this.weight,
    this.specifications,
  }) : reviews = reviews ?? [];

  String get formattedPrice => '\$${price.toStringAsFixed(2)}';
  String get formattedOriginalPrice => originalPrice != null ? '\$${originalPrice!.toStringAsFixed(2)}' : '';
  String get mainImageUrl => imageUrls.isNotEmpty ? imageUrls.first : 'assets/images/placeholder.png';
  
  bool get isOutOfStock => stock <= 0;
  bool get hasDiscount => isOnSale && discountPercentage != null && discountPercentage! > 0;

  Product copyWith({
    bool? isFavorite,
    List<Review>? reviews,
    int? reviewCount,
    double? rating,
  }) {
    return Product(
      id: id,
      name: name,
      description: description,
      price: price,
      imageUrls: imageUrls,
      category: category,
      stock: stock,
      rating: rating ?? this.rating,
      isFavorite: isFavorite ?? this.isFavorite,
      reviewCount: reviewCount ?? this.reviewCount,
      isOnSale: isOnSale,
      originalPrice: originalPrice,
      discountPercentage: discountPercentage,
      reviews: reviews ?? this.reviews,
      brand: brand,
      weight: weight,
      specifications: specifications,
    );
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      imageUrls: List<String>.from(json['imageUrls'] ?? [json['imageUrl'] ?? '']),
      category: json['category'],
      stock: json['stock'],
      rating: (json['rating'] ?? 0.0).toDouble(),
      isFavorite: json['isFavorite'] ?? false,
      reviewCount: json['reviewCount'] ?? 0,
      isOnSale: json['isOnSale'] ?? false,
      originalPrice: json['originalPrice']?.toDouble(),
      discountPercentage: json['discountPercentage']?.toDouble(),
      reviews: (json['reviews'] as List<dynamic>?)
          ?.map((review) => Review.fromJson(review))
          .toList() ?? [],
      brand: json['brand'],
      weight: json['weight'],
      specifications: json['specifications'] != null 
          ? Map<String, String>.from(json['specifications']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrls': imageUrls,
      'imageUrl': imageUrls.isNotEmpty ? imageUrls.first : '',
      'category': category,
      'stock': stock,
      'rating': rating,
      'isFavorite': isFavorite,
      'reviewCount': reviewCount,
      'isOnSale': isOnSale,
      'originalPrice': originalPrice,
      'discountPercentage': discountPercentage,
    };
  }
}

