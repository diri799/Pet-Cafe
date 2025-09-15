import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pawfect_care/core/theme/app_theme.dart';

class BlogDetailScreen extends StatefulWidget {
  final Map<String, dynamic> blog;

  const BlogDetailScreen({
    super.key,
    required this.blog,
  });

  @override
  State<BlogDetailScreen> createState() => _BlogDetailScreenState();
}

class _BlogDetailScreenState extends State<BlogDetailScreen> {
  bool _isLiked = false;
  int _likeCount = 0;
  final List<Map<String, dynamic>> _comments = [];
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _likeCount = widget.blog['likes_count'] ?? 0;
    _loadComments();
  }

  String _formatDate(dynamic dateValue) {
    if (dateValue == null) return 'Unknown date';
    
    try {
      if (dateValue is String) {
        final date = DateTime.parse(dateValue);
        return '${date.day}/${date.month}/${date.year}';
      } else if (dateValue is DateTime) {
        return '${dateValue.day}/${dateValue.month}/${dateValue.year}';
      }
    } catch (e) {
      return 'Unknown date';
    }
    
    return 'Unknown date';
  }

  void _loadComments() {
    // Sample comments with more variety
    _comments.addAll([
      {
        'id': '1',
        'author': 'PetLover123',
        'content': 'Great article! Very helpful information. I learned so much about pet care.',
        'time': '2 hours ago',
        'likes': 5,
      },
      {
        'id': '2',
        'author': 'DogOwner',
        'content': 'Thanks for sharing this. My dog will benefit from these tips. Can\'t wait to try them!',
        'time': '4 hours ago',
        'likes': 3,
      },
      {
        'id': '3',
        'author': 'VetStudent',
        'content': 'As a vet student, I find this very educational. The information is accurate and well-presented.',
        'time': '1 day ago',
        'likes': 8,
      },
      {
        'id': '4',
        'author': 'CatMom',
        'content': 'This is exactly what I needed! My cat has been having similar issues.',
        'time': '1 day ago',
        'likes': 4,
      },
      {
        'id': '5',
        'author': 'AnimalRescuer',
        'content': 'Excellent advice! I work with rescue animals and this information is invaluable.',
        'time': '2 days ago',
        'likes': 12,
      },
      {
        'id': '6',
        'author': 'PetGroomer',
        'content': 'Professional tips that really work. I recommend this to all my clients.',
        'time': '2 days ago',
        'likes': 6,
      },
      {
        'id': '7',
        'author': 'NewPetOwner',
        'content': 'As a first-time pet owner, this article was a lifesaver. Thank you!',
        'time': '3 days ago',
        'likes': 9,
      },
      {
        'id': '8',
        'author': 'PetTrainer',
        'content': 'Great insights! I\'ll be sharing this with my training class.',
        'time': '3 days ago',
        'likes': 7,
      },
    ]);
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Blog Post'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.share, color: Colors.black),
            onPressed: () {
              // Implement share functionality
            },
          ),
          IconButton(
            icon: const Icon(Iconsax.heart, color: Colors.black),
            onPressed: () {
              // Implement bookmark functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Blog Image
            SizedBox(
              width: double.infinity,
              height: 250,
              child: Image.asset(
                widget.blog['image_url'] ?? 'assets/images/pet1.jpg',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: const Icon(
                      Icons.image_not_supported,
                      color: Colors.grey,
                      size: 64,
                    ),
                  );
                },
              ),
            ),
            
            // Blog Content
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      widget.blog['category'] ?? 'General',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Title
                  Text(
                    widget.blog['title'] ?? 'Untitled',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Author and Date
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 20,
                        backgroundColor: AppTheme.primaryColor,
                        child: Icon(
                          Icons.person,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.blog['author'] ?? 'Anonymous',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${_formatDate(widget.blog['created_at'])} • 5 min read',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Content
                  _buildBlogContent(),
                  
                  const SizedBox(height: 32),
                  
                  // Related Articles
                  _buildRelatedArticles(),
                  
                  const SizedBox(height: 32),
                  
                  // Action Buttons
                  _buildActionButtons(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBlogContent() {
    // Extended content based on the blog post
    String fullContent = '';
    
    switch (widget.blog['id']?.toString()) {
      case '1': // Essential Pet Vaccinations
        fullContent = '''
Vaccinations are one of the most important aspects of pet healthcare. They protect your furry friends from potentially life-threatening diseases and help maintain their overall well-being.

## Core Vaccines for Dogs

**Rabies Vaccine**
- Required by law in most areas
- Protects against the deadly rabies virus
- First vaccination at 12-16 weeks, then annually

**DHPP Vaccine**
- Protects against Distemper, Hepatitis, Parvovirus, and Parainfluenza
- Given as a series of shots starting at 6-8 weeks
- Booster shots every 1-3 years

## Core Vaccines for Cats

**FVRCP Vaccine**
- Protects against Feline Viral Rhinotracheitis, Calicivirus, and Panleukopenia
- First series at 6-8 weeks of age
- Annual boosters recommended

**Rabies Vaccine**
- Essential for all cats, especially outdoor cats
- First dose at 12-16 weeks
- Annual or triennial boosters depending on vaccine type

## Vaccination Schedule

It's crucial to follow your veterinarian's recommended vaccination schedule. Puppies and kittens need a series of vaccinations to build immunity, while adult pets need regular boosters to maintain protection.

## Side Effects

Most pets experience minimal side effects from vaccinations. Common mild reactions include:
- Soreness at injection site
- Mild fever
- Lethargy for 24-48 hours

Contact your veterinarian if you notice severe reactions like vomiting, difficulty breathing, or swelling.

Remember, keeping your pet's vaccinations up to date is not just about their health—it's also about protecting other pets and people in your community.
        ''';
        break;
      case '2': // Basic Dog Training Tips
        fullContent = '''
Training your dog is essential for creating a well-behaved, happy companion. Here are fundamental training techniques that every dog owner should master.

## Basic Commands

**Sit Command**
- Hold a treat above your dog's nose
- Move the treat back over their head
- Say "sit" as their bottom touches the ground
- Reward immediately with the treat

**Stay Command**
- Start with your dog in a sit position
- Hold your hand up like a stop sign
- Say "stay" and take a step back
- Gradually increase distance and duration

**Come Command**
- Use a long leash in a safe area
- Say "come" while gently pulling the leash
- Reward with treats and praise when they reach you
- Practice in various environments

## Positive Reinforcement

Always use positive reinforcement techniques:
- Reward good behavior immediately
- Use treats, praise, and play as rewards
- Be consistent with commands and rewards
- Keep training sessions short and fun

## Common Training Mistakes

Avoid these common pitfalls:
- Inconsistent commands
- Punishing after the fact
- Training when frustrated
- Expecting too much too soon

## Training Tips

- Start training early, but it's never too late
- Keep sessions short (5-10 minutes)
- End on a positive note
- Practice in different environments
- Be patient and consistent

Remember, training is an ongoing process that strengthens the bond between you and your dog while ensuring their safety and good behavior.
        ''';
        break;
      default:
        fullContent = widget.blog['content'] ?? 'No content available';
    }

    return Text(
      fullContent,
      style: const TextStyle(
        fontSize: 16,
        height: 1.6,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildRelatedArticles() {
    // Get related articles based on current blog category
    final currentCategory = widget.blog['category'] ?? 'General';
    final relatedArticles = _getRelatedArticles(currentCategory);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Related Articles',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: relatedArticles.length,
            itemBuilder: (context, index) {
              final article = relatedArticles[index];
              return GestureDetector(
                onTap: () {
                  // Navigate to the related article
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => BlogDetailScreen(blog: article),
                    ),
                  );
                },
                child: Container(
                  width: 200,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          child: Image.asset(
                            article['image_url'] ?? 'assets/images/pet${(index % 5) + 1}.jpg',
                            width: double.infinity,
                            height: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[200],
                                child: const Icon(
                                  Icons.pets,
                                  color: Colors.grey,
                                  size: 40,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                article['category'] ?? 'General',
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              article['title'] ?? 'Untitled',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                height: 1.2,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${article['read_time'] ?? 3} min read',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  List<Map<String, dynamic>> _getRelatedArticles(String currentCategory) {
    // Sample related articles based on category
    final allArticles = [
      {
        'id': '1',
        'title': 'Essential Pet Vaccinations',
        'category': 'Health',
        'image_url': 'assets/images/pet1.jpg',
        'read_time': 5,
        'author': 'Dr. Sarah Johnson',
        'created_at': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
        'content': 'Vaccinations are crucial for your pet\'s health...',
        'likes_count': 42,
        'comments_count': 8,
      },
      {
        'id': '2',
        'title': 'Basic Dog Training Tips',
        'category': 'Training',
        'image_url': 'assets/images/pet2.jpg',
        'read_time': 4,
        'author': 'Mike Trainer',
        'created_at': DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
        'content': 'Training your dog is essential for creating a well-behaved companion...',
        'likes_count': 38,
        'comments_count': 12,
      },
      {
        'id': '3',
        'title': 'Nutritional Needs for Different Dog Breeds',
        'category': 'Nutrition',
        'image_url': 'assets/images/pet3.jpg',
        'read_time': 6,
        'author': 'Dr. Lisa Chen',
        'created_at': DateTime.now().subtract(const Duration(days: 3)).toIso8601String(),
        'content': 'Different dog breeds have different nutritional requirements...',
        'likes_count': 29,
        'comments_count': 5,
      },
      {
        'id': '4',
        'title': 'Grooming Your Cat: A Complete Guide',
        'category': 'Grooming',
        'image_url': 'assets/images/pet4.jpg',
        'read_time': 4,
        'author': 'Emma Groomer',
        'created_at': DateTime.now().subtract(const Duration(days: 4)).toIso8601String(),
        'content': 'Regular grooming is essential for your cat\'s health...',
        'likes_count': 35,
        'comments_count': 9,
      },
      {
        'id': '5',
        'title': 'Understanding Pet Behavior: Signs to Watch For',
        'category': 'Behavior',
        'image_url': 'assets/images/pet5.jpg',
        'read_time': 5,
        'author': 'Dr. James Wilson',
        'created_at': DateTime.now().subtract(const Duration(days: 5)).toIso8601String(),
        'content': 'Learn to read your pet\'s body language...',
        'likes_count': 31,
        'comments_count': 7,
      },
      {
        'id': '6',
        'title': 'Creating a Pet-Friendly Home Environment',
        'category': 'General',
        'image_url': 'assets/images/pet6.jpg',
        'read_time': 3,
        'author': 'Sarah Home',
        'created_at': DateTime.now().subtract(const Duration(days: 6)).toIso8601String(),
        'content': 'Transform your home into a safe and comfortable space...',
        'likes_count': 27,
        'comments_count': 4,
      },
    ];

    // Filter articles by category and exclude current article
    final currentId = widget.blog['id']?.toString();
    final related = allArticles
        .where((article) => 
            article['category'] == currentCategory && 
            article['id'] != currentId)
        .toList();

    // If not enough related articles in same category, add others
    if (related.length < 3) {
      final others = allArticles
          .where((article) => 
              article['category'] != currentCategory && 
              article['id'] != currentId)
          .take(3 - related.length)
          .toList();
      related.addAll(others);
    }

    return related.take(3).toList();
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // Like and Comment Row
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    _isLiked = !_isLiked;
                    _likeCount += _isLiked ? 1 : -1;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_isLiked ? 'Liked!' : 'Unliked'),
                      backgroundColor: _isLiked ? Colors.red : Colors.grey,
                    ),
                  );
                },
                icon: Icon(
                  _isLiked ? Iconsax.heart5 : Iconsax.heart,
                  color: _isLiked ? Colors.red : AppTheme.primaryColor,
                ),
                label: Text('Like ($_likeCount)'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _isLiked ? Colors.red : AppTheme.primaryColor,
                  side: BorderSide(
                    color: _isLiked ? Colors.red : AppTheme.primaryColor,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  _showCommentsModal(context);
                },
                icon: const Icon(Iconsax.message),
                label: Text('Comment (${_comments.length})'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 12),
        
        // Bookmark and Share Row
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Article bookmarked'),
                      backgroundColor: AppTheme.primaryColor,
                    ),
                  );
                },
                icon: const Icon(Iconsax.bookmark),
                label: const Text('Bookmark'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primaryColor,
                  side: const BorderSide(color: AppTheme.primaryColor),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Article shared'),
                      backgroundColor: AppTheme.primaryColor,
                    ),
                  );
                },
                icon: const Icon(Iconsax.share),
                label: const Text('Share'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showCommentsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        expand: false,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Comments header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Comments (${_comments.length})',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              
              // Comments list
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _comments.length,
                  itemBuilder: (context, index) {
                    final comment = _comments[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CircleAvatar(
                            radius: 16,
                            backgroundColor: AppTheme.primaryColor,
                            child: Icon(
                              Icons.person,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      comment['author'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      comment['time'],
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  comment['content'],
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          comment['likes'] = (comment['likes'] as int) + 1;
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            Iconsax.heart,
                                            size: 14,
                                            color: Colors.grey[400],
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${comment['likes']}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    GestureDetector(
                                      onTap: () {
                                        // Reply functionality
                                      },
                                      child: Text(
                                        'Reply',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              
              // Comment input
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  border: Border(
                    top: BorderSide(color: Colors.grey[200]!),
                  ),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 16,
                      backgroundColor: AppTheme.primaryColor,
                      child: Icon(
                        Icons.person,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        decoration: InputDecoration(
                          hintText: 'Add a comment...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () {
                        if (_commentController.text.isNotEmpty) {
                          setState(() {
                            _comments.insert(0, {
                              'id': DateTime.now().millisecondsSinceEpoch.toString(),
                              'author': 'You',
                              'content': _commentController.text,
                              'time': 'now',
                              'likes': 0,
                            });
                          });
                          _commentController.clear();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Comment added!'),
                              backgroundColor: AppTheme.primaryColor,
                            ),
                          );
                        }
                      },
                      icon: const Icon(
                        Iconsax.send_1,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
