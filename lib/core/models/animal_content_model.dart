class AnimalContent {
  final int id;
  final String title;
  final String description;
  final String mediaPath;
  final ContentType type;
  final String category;
  final List<String> tags;
  final int likes;
  final int comments;
  final int shares;
  final String authorName;
  final String authorAvatar;
  final DateTime createdAt;
  final bool isLiked;
  final bool isFollowing;

  AnimalContent({
    required this.id,
    required this.title,
    required this.description,
    required this.mediaPath,
    required this.type,
    required this.category,
    required this.tags,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.authorName,
    required this.authorAvatar,
    required this.createdAt,
    this.isLiked = false,
    this.isFollowing = false,
  });

  factory AnimalContent.fromMap(Map<String, dynamic> map) {
    return AnimalContent(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      mediaPath: map['media_path'],
      type: ContentType.fromString(map['type']),
      category: map['category'],
      tags: (map['tags'] as String).split(',').where((tag) => tag.isNotEmpty).toList(),
      likes: map['likes'] ?? 0,
      comments: map['comments'] ?? 0,
      shares: map['shares'] ?? 0,
      authorName: map['author_name'],
      authorAvatar: map['author_avatar'],
      createdAt: DateTime.parse(map['created_at']),
      isLiked: map['is_liked'] == 1,
      isFollowing: map['is_following'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'media_path': mediaPath,
      'type': type.toString().split('.').last,
      'category': category,
      'tags': tags.join(','),
      'likes': likes,
      'comments': comments,
      'shares': shares,
      'author_name': authorName,
      'author_avatar': authorAvatar,
      'created_at': createdAt.toIso8601String(),
      'is_liked': isLiked ? 1 : 0,
      'is_following': isFollowing ? 1 : 0,
    };
  }

  AnimalContent copyWith({
    int? id,
    String? title,
    String? description,
    String? mediaPath,
    ContentType? type,
    String? category,
    List<String>? tags,
    int? likes,
    int? comments,
    int? shares,
    String? authorName,
    String? authorAvatar,
    DateTime? createdAt,
    bool? isLiked,
    bool? isFollowing,
  }) {
    return AnimalContent(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      mediaPath: mediaPath ?? this.mediaPath,
      type: type ?? this.type,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      shares: shares ?? this.shares,
      authorName: authorName ?? this.authorName,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      createdAt: createdAt ?? this.createdAt,
      isLiked: isLiked ?? this.isLiked,
      isFollowing: isFollowing ?? this.isFollowing,
    );
  }
}

enum ContentType {
  image,
  video;

  static ContentType fromString(String type) {
    switch (type.toLowerCase()) {
      case 'video':
        return ContentType.video;
      case 'image':
      default:
        return ContentType.image;
    }
  }

  String get displayName {
    switch (this) {
      case ContentType.image:
        return 'Image';
      case ContentType.video:
        return 'Video';
    }
  }
}

class AnimalContentCategory {
  final String name;
  final String icon;
  final int count;

  AnimalContentCategory({
    required this.name,
    required this.icon,
    required this.count,
  });
}

