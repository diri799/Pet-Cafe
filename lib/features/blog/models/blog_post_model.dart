class BlogPost {
  final String id;
  final String title;
  final String content;
  final String author;
  final String authorRole; // admin, vet
  final List<String> tags;
  final String category;
  final String? featuredImage;
  final DateTime publishedAt;
  final DateTime updatedAt;
  final bool isPublished;
  final int readCount;

  BlogPost({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.authorRole,
    required this.tags,
    required this.category,
    this.featuredImage,
    required this.publishedAt,
    required this.updatedAt,
    required this.isPublished,
    this.readCount = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'author': author,
      'author_role': authorRole,
      'tags': tags.join(','),
      'category': category,
      'featured_image': featuredImage,
      'published_at': publishedAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_published': isPublished ? 1 : 0,
      'read_count': readCount,
    };
  }

  factory BlogPost.fromMap(Map<String, dynamic> map) {
    return BlogPost(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      author: map['author'],
      authorRole: map['author_role'],
      tags: map['tags']?.split(',').where((s) => s.isNotEmpty).toList() ?? [],
      category: map['category'],
      featuredImage: map['featured_image'],
      publishedAt: DateTime.parse(map['published_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      isPublished: map['is_published'] == 1,
      readCount: map['read_count'] ?? 0,
    );
  }

  BlogPost copyWith({
    String? id,
    String? title,
    String? content,
    String? author,
    String? authorRole,
    List<String>? tags,
    String? category,
    String? featuredImage,
    DateTime? publishedAt,
    DateTime? updatedAt,
    bool? isPublished,
    int? readCount,
  }) {
    return BlogPost(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      author: author ?? this.author,
      authorRole: authorRole ?? this.authorRole,
      tags: tags ?? this.tags,
      category: category ?? this.category,
      featuredImage: featuredImage ?? this.featuredImage,
      publishedAt: publishedAt ?? this.publishedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isPublished: isPublished ?? this.isPublished,
      readCount: readCount ?? this.readCount,
    );
  }

  String get excerpt {
    if (content.length <= 150) return content;
    return '${content.substring(0, 150)}...';
  }

  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(publishedAt);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks week${weeks == 1 ? '' : 's'} ago';
    } else {
      return '${publishedAt.day}/${publishedAt.month}/${publishedAt.year}';
    }
  }
}
