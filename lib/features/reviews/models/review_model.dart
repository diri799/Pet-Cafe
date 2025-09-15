class Review {
  final String id;
  final String productId;
  final String userId;
  final String userName;
  final String userAvatar;
  final double rating;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int helpfulCount;
  final bool isVerified;

  const Review({
    required this.id,
    required this.productId,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.rating,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.helpfulCount = 0,
    this.isVerified = false,
  });

  factory Review.empty() => Review(
        id: '',
        productId: '',
        userId: '',
        userName: '',
        userAvatar: '',
        rating: 0.0,
        title: '',
        content: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json['id'] ?? '',
        productId: json['productId'] ?? '',
        userId: json['userId'] ?? '',
        userName: json['userName'] ?? '',
        userAvatar: json['userAvatar'] ?? '',
        rating: (json['rating'] ?? 0.0).toDouble(),
        title: json['title'] ?? '',
        content: json['content'] ?? '',
        createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
        updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
        helpfulCount: json['helpfulCount'] ?? 0,
        isVerified: json['isVerified'] ?? false,
      );

  // Helper methods
  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    
    if (difference.inDays > 7) {
      return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }

  Review copyWith({
    String? id,
    String? productId,
    String? userId,
    String? userName,
    String? userAvatar,
    double? rating,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? helpfulCount,
    bool? isVerified,
  }) {
    return Review(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      rating: rating ?? this.rating,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      helpfulCount: helpfulCount ?? this.helpfulCount,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  // Convert to map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product_id': productId,
      'user_id': userId,
      'user_name': userName,
      'user_avatar': userAvatar,
      'rating': rating,
      'title': title,
      'content': content,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'helpful_count': helpfulCount,
      'is_verified': isVerified ? 1 : 0,
    };
  }

  // Create from database map
  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      id: map['id'] ?? '',
      productId: map['product_id'] ?? '',
      userId: map['user_id'] ?? '',
      userName: map['user_name'] ?? '',
      userAvatar: map['user_avatar'] ?? '',
      rating: (map['rating'] ?? 0.0).toDouble(),
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      createdAt: DateTime.parse(map['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(map['updated_at'] ?? DateTime.now().toIso8601String()),
      helpfulCount: map['helpful_count'] ?? 0,
      isVerified: (map['is_verified'] ?? 0) == 1,
    );
  }
}