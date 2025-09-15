class BlogPost {
  final int id;
  final int authorId;
  final String title;
  final String content;
  final String category;
  final String tags;
  final String imageUrl;
  final bool published;
  final int likesCount;
  final int commentsCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  BlogPost({
    required this.id,
    required this.authorId,
    required this.title,
    required this.content,
    required this.category,
    required this.tags,
    required this.imageUrl,
    required this.published,
    required this.likesCount,
    required this.commentsCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BlogPost.fromMap(Map<String, dynamic> map) {
    return BlogPost(
      id: map['id'] ?? 0,
      authorId: map['author_id'] ?? 1,
      title: map['title'] ?? 'Untitled',
      content: map['content'] ?? '',
      category: map['category'] ?? 'General',
      tags: map['tags'] ?? '',
      imageUrl: map['image_url'] ?? '',
      published: (map['published'] ?? 0) == 1,
      likesCount: map['likes_count'] ?? 0,
      commentsCount: map['comments_count'] ?? 0,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : DateTime.now(),
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'author_id': authorId,
      'title': title,
      'content': content,
      'category': category,
      'tags': tags,
      'image_url': imageUrl,
      'published': published ? 1 : 0,
      'likes_count': likesCount,
      'comments_count': commentsCount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  BlogPost copyWith({
    int? id,
    int? authorId,
    String? title,
    String? content,
    String? category,
    String? tags,
    String? imageUrl,
    bool? published,
    int? likesCount,
    int? commentsCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BlogPost(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      imageUrl: imageUrl ?? this.imageUrl,
      published: published ?? this.published,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  List<String> get tagList {
    return tags
        .split(',')
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .toList();
  }

  String get excerpt {
    if (content.length <= 200) return content;
    return '${content.substring(0, 200)}...';
  }
}

enum BlogCategory {
  health,
  nutrition,
  training,
  grooming,
  behavior,
  general;

  static BlogCategory fromString(String category) {
    switch (category.toLowerCase()) {
      case 'health':
        return BlogCategory.health;
      case 'nutrition':
        return BlogCategory.nutrition;
      case 'training':
        return BlogCategory.training;
      case 'grooming':
        return BlogCategory.grooming;
      case 'behavior':
        return BlogCategory.behavior;
      default:
        return BlogCategory.general;
    }
  }

  String get displayName {
    switch (this) {
      case BlogCategory.health:
        return 'Health';
      case BlogCategory.nutrition:
        return 'Nutrition';
      case BlogCategory.training:
        return 'Training';
      case BlogCategory.grooming:
        return 'Grooming';
      case BlogCategory.behavior:
        return 'Behavior';
      case BlogCategory.general:
        return 'General';
    }
  }
}
