import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pawfect_care/core/database/database_helper.dart';
import 'package:pawfect_care/core/models/blog_model.dart';

class BlogNotifier extends StateNotifier<List<BlogPost>> {
  BlogNotifier() : super([]);

  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<void> loadBlogPosts() async {
    try {
      if (kIsWeb) {
        // Use sample data for web platform
        state = _getSampleBlogPosts();
      } else {
        // Use database for mobile platforms
        final blogMaps = await _dbHelper.query(
          'blog_posts',
          where: 'published = ?',
          whereArgs: [1],
        );
        state = blogMaps.map((map) => BlogPost.fromMap(map)).toList();
      }
    } catch (e) {
      // Fallback to sample data if database fails
      state = _getSampleBlogPosts();
    }
  }

  Future<void> addBlogPost(BlogPost blogPost) async {
    try {
      if (kIsWeb) {
        // For web, just add to state
        state = [blogPost, ...state];
      } else {
        // For mobile, save to database
        await _dbHelper.insert('blog_posts', blogPost.toMap());
        state = [blogPost, ...state];
      }
    } catch (e) {
      // Handle error
    }
  }

  List<BlogPost> _getSampleBlogPosts() {
    return [
      BlogPost(
        id: 1,
        authorId: 1,
        title: 'Essential Grooming Tips for Your Dog',
        content: 'Learn the fundamentals of dog grooming including brushing techniques, nail trimming, ear cleaning, and dental care. Regular grooming not only keeps your dog looking great but also promotes good health and strengthens your bond.',
        category: 'Grooming',
        tags: 'grooming,dog care,health,hygiene',
        imageUrl: 'assets/images/pet2.jpg',
        published: true,
        likesCount: 124,
        commentsCount: 31,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      BlogPost(
        id: 2,
        authorId: 1,
        title: 'Understanding Your Cat\'s Behavior',
        content: 'Decode the mysterious world of feline behavior! From purring and kneading to hiding and scratching, learn what your cat is trying to tell you and how to respond appropriately to their needs.',
        category: 'Behavior',
        tags: 'cat behavior,communication,pets,understanding',
        imageUrl: 'assets/images/pet3.jpg',
        published: true,
        likesCount: 89,
        commentsCount: 22,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        updatedAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      BlogPost(
        id: 3,
        authorId: 1,
        title: 'Creating a Pet-Friendly Home Environment',
        content: 'Transform your home into a safe and comfortable haven for your pets. Learn about pet-proofing, creating designated spaces, choosing pet-safe plants, and organizing your home for optimal pet happiness.',
        category: 'Environment',
        tags: 'home,pet safety,environment,organization',
        imageUrl: 'assets/images/pet4.jpg',
        published: true,
        likesCount: 156,
        commentsCount: 45,
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
        updatedAt: DateTime.now().subtract(const Duration(days: 4)),
      ),
      BlogPost(
        id: 4,
        authorId: 1,
        title: 'Nutrition Guide for Senior Pets',
        content: 'As pets age, their nutritional needs change significantly. Discover the best diet options, supplements, and feeding schedules for senior dogs and cats to ensure they maintain optimal health in their golden years.',
        category: 'Nutrition',
        tags: 'senior pets,nutrition,diet,health,aging',
        imageUrl: 'assets/images/pet5.jpg',
        published: true,
        likesCount: 98,
        commentsCount: 28,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        updatedAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      BlogPost(
        id: 5,
        authorId: 1,
        title: 'Training Your Puppy: The First 6 Months',
        content: 'Master the art of puppy training with our comprehensive guide covering house training, basic commands, socialization, and behavior management. Set your puppy up for a lifetime of good behavior and happiness.',
        category: 'Training',
        tags: 'puppy training,obedience,socialization,behavior',
        imageUrl: 'assets/images/pet6.jpg',
        published: true,
        likesCount: 203,
        commentsCount: 67,
        createdAt: DateTime.now().subtract(const Duration(days: 6)),
        updatedAt: DateTime.now().subtract(const Duration(days: 6)),
      ),
      BlogPost(
        id: 6,
        authorId: 1,
        title: 'Mental Stimulation Games for Indoor Cats',
        content: 'Keep your indoor cat mentally sharp and physically active with these engaging games and activities. From puzzle feeders to interactive toys, discover creative ways to enrich your cat\'s daily routine.',
        category: 'Enrichment',
        tags: 'indoor cats,mental stimulation,games,enrichment',
        imageUrl: 'assets/images/pet8.jpg',
        published: true,
        likesCount: 142,
        commentsCount: 39,
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        updatedAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
      BlogPost(
        id: 7,
        authorId: 1,
        title: 'Recognizing Signs of Pet Stress and Anxiety',
        content: 'Learn to identify the subtle and not-so-subtle signs of stress and anxiety in your pets. Understanding these signals is crucial for providing timely support and creating a calm, comfortable environment for your furry friends.',
        category: 'Health',
        tags: 'stress,anxiety,pet health,behavior,signs',
        imageUrl: 'assets/images/pet9.jpg',
        published: true,
        likesCount: 167,
        commentsCount: 52,
        createdAt: DateTime.now().subtract(const Duration(days: 8)),
        updatedAt: DateTime.now().subtract(const Duration(days: 8)),
      ),
      BlogPost(
        id: 8,
        authorId: 1,
        title: 'First Aid for Pets: Essential Emergency Care',
        content: 'Learn the basics of pet first aid to handle emergencies until you can reach a veterinarian. This knowledge could save your pet\'s life in critical situations.',
        category: 'Health',
        tags: 'first aid,emergency,health,safety',
        imageUrl: 'assets/images/pet1.jpg',
        published: true,
        likesCount: 89,
        commentsCount: 23,
        createdAt: DateTime.now().subtract(const Duration(days: 9)),
        updatedAt: DateTime.now().subtract(const Duration(days: 9)),
      ),
      BlogPost(
        id: 9,
        authorId: 1,
        title: 'Traveling with Pets: A Complete Guide',
        content: 'Make traveling with your pet stress-free with our comprehensive guide covering preparation, safety tips, and destination considerations.',
        category: 'General',
        tags: 'travel,pets,safety,preparation',
        imageUrl: 'assets/images/pet7.jpg',
        published: true,
        likesCount: 37,
        commentsCount: 8,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        updatedAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
    ];
  }
}

final blogProvider = StateNotifierProvider<BlogNotifier, List<BlogPost>>((ref) {
  return BlogNotifier();
});
