import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pawfect_care/core/theme/app_theme.dart';
import 'package:pawfect_care/features/blog/models/blog_post_model.dart';
import 'package:pawfect_care/features/blog/screens/blog_detail_screen.dart';
import 'package:pawfect_care/core/services/auth_service.dart';

class BlogListScreen extends ConsumerStatefulWidget {
  const BlogListScreen({super.key});

  @override
  ConsumerState<BlogListScreen> createState() => _BlogListScreenState();
}

class _BlogListScreenState extends ConsumerState<BlogListScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';

  final List<String> _categories = [
    'All',
    'Training',
    'Nutrition',
    'Health',
    'First Aid',
    'Grooming',
    'Behavior',
  ];

    final List<BlogPost> _blogPosts = [
    BlogPost(
      id: '1',
      title: 'Essential Vaccination Schedule for Dogs',
      content: 'Keeping your dog healthy starts with a proper vaccination schedule. Here\'s everything you need to know about when and why your furry friend needs their shots...',
      author: 'Dr. Sarah Johnson',
      authorRole: 'vet',
      tags: ['vaccination', 'health', 'dogs', 'prevention'],
      category: 'Health',
      featuredImage: 'https://images.unsplash.com/photo-1551717743-49959800b1f6?w=400&h=300&fit=crop',
      publishedAt: DateTime.now().subtract(const Duration(days: 2)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
      isPublished: true,
      readCount: 245,
    ),
    BlogPost(
      id: '2',
      title: 'Training Your Puppy: Basic Commands',
      content: 'Teaching your puppy basic commands is essential for their safety and your peace of mind. Start with these fundamental commands...',
      author: 'Dr. Mike Chen',
      authorRole: 'vet',
      tags: ['training', 'puppy', 'commands', 'behavior'],
      category: 'Training',
      featuredImage: 'https://images.unsplash.com/photo-1601758228041-f3b2795255f1?w=400&h=300&fit=crop',
      publishedAt: DateTime.now().subtract(const Duration(days: 5)),
      updatedAt: DateTime.now().subtract(const Duration(days: 5)),
      isPublished: true,
      readCount: 189,
    ),
    BlogPost(
      id: '3',
      title: 'Proper Nutrition for Senior Cats',
      content: 'As cats age, their nutritional needs change. Learn how to provide the best diet for your senior feline companion...',
      author: 'Dr. Lisa Rodriguez',
      authorRole: 'vet',
      tags: ['nutrition', 'cats', 'senior', 'health'],
      category: 'Nutrition',
      featuredImage: 'https://images.unsplash.com/photo-1574158622682-e40e69881006?w=400&h=300&fit=crop',
      publishedAt: DateTime.now().subtract(const Duration(days: 7)),
      updatedAt: DateTime.now().subtract(const Duration(days: 7)),
      isPublished: true,
      readCount: 156,
    ),
    BlogPost(
      id: '4',
      title: 'First Aid for Pet Emergencies',
      content: 'Knowing basic first aid for pets can save your furry friend\'s life in an emergency. Here are the essential steps to take...',
      author: 'Dr. James Wilson',
      authorRole: 'vet',
      tags: ['first aid', 'emergency', 'safety', 'health'],
      category: 'First Aid',
      featuredImage: 'https://images.unsplash.com/photo-1583337130417-3346a1be7dee?w=400&h=300&fit=crop',
      publishedAt: DateTime.now().subtract(const Duration(days: 10)),
      updatedAt: DateTime.now().subtract(const Duration(days: 10)),
      isPublished: true,
      readCount: 312,
    ),
    BlogPost(
      id: '5',
      title: 'Grooming Tips for Long-Haired Dogs',
      content: 'Maintaining a long-haired dog\'s coat requires special attention. Follow these grooming tips to keep your dog looking and feeling great...',
      author: 'Sarah Thompson',
      authorRole: 'admin',
      tags: ['grooming', 'dogs', 'coat care', 'maintenance'],
      category: 'Grooming',
      featuredImage: 'https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=400&h=300&fit=crop',
      publishedAt: DateTime.now().subtract(const Duration(days: 12)),
      updatedAt: DateTime.now().subtract(const Duration(days: 12)),
      isPublished: true,
      readCount: 98,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filteredPosts = _getFilteredPosts();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet Care Tips'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_2),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              // Use role-based navigation
              final authService = AuthService();
              final dashboardRoute = authService.getDashboardRoute();
              context.go(dashboardRoute);
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.add),
            onPressed: () => context.go('/blog/create'),
          ),
          IconButton(
            icon: const Icon(Iconsax.search_normal_1),
            onPressed: () => _showSearchDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Filter
          _buildCategoryFilter(),
          
          // Blog Posts List
          Expanded(
            child: filteredPosts.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredPosts.length,
                    itemBuilder: (context, index) {
                      final post = filteredPosts[index];
                      return _buildBlogPostCard(post);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category;
          
          return Container(
            margin: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = category;
                });
              },
              selectedColor: AppTheme.primaryColor.withValues(alpha: 0.2),
              checkmarkColor: AppTheme.primaryColor,
              labelStyle: TextStyle(
                color: isSelected ? AppTheme.primaryColor : Colors.grey[600],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBlogPostCard(BlogPost post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _openBlogPost(post),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Featured Image
            if (post.featuredImage != null) ...[
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                  ),
                  child: Image.network(
                    post.featuredImage!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: Icon(
                          Icons.image,
                          size: 50,
                          color: Colors.grey[400],
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Colors.grey[200],
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(post.category).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          post.category,
                          style: TextStyle(
                            color: _getCategoryColor(post.category),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Iconsax.bookmark,
                        size: 20,
                        color: Colors.grey[400],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Title
                  Text(
                    post.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Content Preview
                  Text(
                    post.excerpt,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),

                  // Tags
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: post.tags.take(3).map((tag) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '#$tag',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[600],
                        ),
                      ),
                    )).toList(),
                  ),
                  const SizedBox(height: 12),

                  // Footer
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.grey[200],
                        child: Text(
                          post.author.substring(0, 1),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post.author,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              post.formattedDate,
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Iconsax.eye,
                            size: 14,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${post.readCount}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
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
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.document_text,
            size: 100,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 24),
          Text(
            'No Articles Found',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filter',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  List<BlogPost> _getFilteredPosts() {
    var filtered = _blogPosts.where((post) => post.isPublished);

    // Filter by category
    if (_selectedCategory != 'All') {
      filtered = filtered.where((post) => post.category == _selectedCategory);
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((post) =>
          post.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          post.content.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          post.tags.any((tag) => tag.toLowerCase().contains(_searchQuery.toLowerCase())));
    }

    // Sort by published date (newest first)
    return filtered.toList()
      ..sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Health':
        return Colors.green;
      case 'Training':
        return Colors.blue;
      case 'Nutrition':
        return Colors.orange;
      case 'First Aid':
        return Colors.red;
      case 'Grooming':
        return Colors.purple;
      case 'Behavior':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Articles'),
        content: TextField(
          decoration: const InputDecoration(
            hintText: 'Search by title, content, or tags...',
            prefixIcon: Icon(Iconsax.search_normal_1),
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _searchQuery = '';
              });
              Navigator.of(context).pop();
            },
            child: const Text('Clear'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  void _openBlogPost(BlogPost post) {
    // Convert BlogPost to Map for the detail screen
    final blogMap = {
      'id': post.id,
      'title': post.title,
      'content': post.content,
      'author': post.author,
      'date': post.publishedAt.toIso8601String(),
      'category': post.category,
      'tags': post.tags,
      'likes_count': post.readCount,
      'featured_image': post.featuredImage,
    };
    
    // Use Navigator.push instead of context.push for more reliable navigation
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlogDetailScreen(blog: blogMap),
      ),
    );
  }
}