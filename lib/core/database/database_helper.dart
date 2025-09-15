import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    
    // Skip database initialization on web platform
    if (kIsWeb) {
      throw UnsupportedError('Database not supported on web platform');
    }
    
    _database = await _initDB('pawfect_care.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    // Users table
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        phone TEXT,
        role TEXT NOT NULL CHECK(role IN ('pet_owner', 'veterinarian', 'shelter_admin')),
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Pets table
    await db.execute('''
      CREATE TABLE pets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        species TEXT NOT NULL,
        breed TEXT,
        age INTEGER,
        gender TEXT CHECK(gender IN ('male', 'female', 'other')),
        photo TEXT,
        description TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Pet Health Records table
    await db.execute('''
      CREATE TABLE pet_health_records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        pet_id INTEGER NOT NULL,
        veterinarian_id INTEGER,
        visit_date TEXT NOT NULL,
        diagnosis TEXT,
        prescription TEXT,
        treatment_notes TEXT,
        next_due_date TEXT,
        record_type TEXT NOT NULL CHECK(record_type IN ('vaccination', 'checkup', 'treatment', 'deworming')),
        created_at TEXT NOT NULL,
        FOREIGN KEY (pet_id) REFERENCES pets (id) ON DELETE CASCADE,
        FOREIGN KEY (veterinarian_id) REFERENCES users (id)
      )
    ''');

    // Appointments table
    await db.execute('''
      CREATE TABLE appointments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        pet_id INTEGER NOT NULL,
        veterinarian_id INTEGER,
        shelter_id INTEGER,
        appointment_date TEXT NOT NULL,
        appointment_time TEXT NOT NULL,
        status TEXT NOT NULL CHECK(status IN ('scheduled', 'confirmed', 'completed', 'cancelled', 'rescheduled')),
        reason TEXT,
        notes TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (pet_id) REFERENCES pets (id) ON DELETE CASCADE,
        FOREIGN KEY (veterinarian_id) REFERENCES users (id),
        FOREIGN KEY (shelter_id) REFERENCES users (id)
      )
    ''');

    // Shelter Pets table (for adoption)
    await db.execute('''
      CREATE TABLE shelter_pets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        shelter_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        species TEXT NOT NULL,
        breed TEXT,
        age INTEGER,
        gender TEXT CHECK(gender IN ('male', 'female', 'other')),
        photo TEXT,
        description TEXT,
        health_status TEXT,
        adoption_status TEXT NOT NULL CHECK(adoption_status IN ('available', 'pending', 'adopted')),
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (shelter_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Adoption Requests table
    await db.execute('''
      CREATE TABLE adoption_requests (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        shelter_pet_id INTEGER NOT NULL,
        requester_id INTEGER NOT NULL,
        request_date TEXT NOT NULL,
        status TEXT NOT NULL CHECK(status IN ('pending', 'approved', 'rejected')),
        notes TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (shelter_pet_id) REFERENCES shelter_pets (id) ON DELETE CASCADE,
        FOREIGN KEY (requester_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Blog Posts table
    await db.execute('''
      CREATE TABLE blog_posts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        author_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        category TEXT,
        tags TEXT,
        image_url TEXT,
        published BOOLEAN NOT NULL DEFAULT 0,
        likes_count INTEGER DEFAULT 0,
        comments_count INTEGER DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (author_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Blog Likes table
    await db.execute('''
      CREATE TABLE blog_likes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        blog_post_id INTEGER NOT NULL,
        user_id INTEGER NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY (blog_post_id) REFERENCES blog_posts (id) ON DELETE CASCADE,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
        UNIQUE(blog_post_id, user_id)
      )
    ''');

    // Blog Comments table
    await db.execute('''
      CREATE TABLE blog_comments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        blog_post_id INTEGER NOT NULL,
        user_id INTEGER NOT NULL,
        content TEXT NOT NULL,
        likes_count INTEGER DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (blog_post_id) REFERENCES blog_posts (id) ON DELETE CASCADE,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Product reviews table
    await db.execute('''
      CREATE TABLE product_reviews (
        id TEXT PRIMARY KEY,
        product_id TEXT NOT NULL,
        user_id TEXT NOT NULL,
        user_name TEXT NOT NULL,
        user_avatar TEXT NOT NULL,
        rating REAL NOT NULL CHECK(rating >= 1 AND rating <= 5),
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        helpful_count INTEGER DEFAULT 0,
        is_verified INTEGER DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Products table (for external store integration)
    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        price REAL NOT NULL,
        category TEXT NOT NULL,
        image_url TEXT,
        external_url TEXT,
        brand TEXT,
        stock INTEGER DEFAULT 0,
        rating REAL DEFAULT 0.0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Cart table
    await db.execute('''
      CREATE TABLE cart (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        product_id TEXT NOT NULL,
        quantity INTEGER NOT NULL DEFAULT 1,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Orders table
    await db.execute('''
      CREATE TABLE orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        order_number TEXT UNIQUE NOT NULL,
        status TEXT NOT NULL CHECK(status IN ('pending', 'confirmed', 'shipped', 'delivered', 'cancelled')),
        total_amount REAL NOT NULL,
        shipping_address TEXT NOT NULL,
        billing_address TEXT,
        payment_method TEXT NOT NULL,
        payment_status TEXT NOT NULL CHECK(payment_status IN ('pending', 'paid', 'failed', 'refunded')),
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Order Items table
    await db.execute('''
      CREATE TABLE order_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        order_id INTEGER NOT NULL,
        product_id TEXT NOT NULL,
        product_name TEXT NOT NULL,
        product_price REAL NOT NULL,
        quantity INTEGER NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY (order_id) REFERENCES orders (id) ON DELETE CASCADE
      )
    ''');

    // Payment Information table
    await db.execute('''
      CREATE TABLE payment_info (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        card_type TEXT,
        last_four_digits TEXT,
        expiry_month INTEGER,
        expiry_year INTEGER,
        billing_address TEXT,
        is_default BOOLEAN NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Shipping Addresses table
    await db.execute('''
      CREATE TABLE shipping_addresses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        full_name TEXT NOT NULL,
        address_line1 TEXT NOT NULL,
        address_line2 TEXT,
        city TEXT NOT NULL,
        state TEXT NOT NULL,
        postal_code TEXT NOT NULL,
        country TEXT NOT NULL DEFAULT 'USA',
        phone TEXT,
        is_default BOOLEAN NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Notifications table
    await db.execute('''
      CREATE TABLE notifications (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        body TEXT NOT NULL,
        type TEXT NOT NULL CHECK(type IN ('appointment', 'vaccination', 'blog', 'adoption')),
        data TEXT,
        read BOOLEAN NOT NULL DEFAULT 0,
        scheduled_for TEXT,
        created_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Insert sample data
    await _insertSampleData(db);
  }

  Future _insertSampleData(Database db) async {
    // Insert sample users
    await db.insert('users', {
      'name': 'John Doe',
      'email': 'john@example.com',
      'password': 'password123',
      'phone': '+1234567890',
      'role': 'pet_owner',
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });

    await db.insert('users', {
      'name': 'Dr. Sarah Wilson',
      'email': 'dr.sarah@vet.com',
      'password': 'vetpass123',
      'phone': '+1234567891',
      'role': 'veterinarian',
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });

    await db.insert('users', {
      'name': 'Happy Paws Shelter',
      'email': 'admin@shelter.com',
      'password': 'shelterpass123',
      'phone': '+1234567892',
      'role': 'shelter_admin',
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });

    // Insert sample pets
    await db.insert('pets', {
      'user_id': 1,
      'name': 'Max',
      'species': 'Dog',
      'breed': 'Golden Retriever',
      'age': 3,
      'gender': 'male',
      'photo': 'assets/images/dog1.jpg',
      'description': 'Friendly and energetic golden retriever',
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });

    // Insert sample shelter pets
    await db.insert('shelter_pets', {
      'shelter_id': 3,
      'name': 'Bella',
      'species': 'Dog',
      'breed': 'Siberian Husky',
      'age': 2,
      'gender': 'female',
      'photo': 'assets/images/dog2.jpg',
      'description': 'Beautiful husky looking for a loving home',
      'health_status': 'Healthy',
      'adoption_status': 'available',
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });

    // Insert sample blog posts
    await db.insert('blog_posts', {
      'author_id': 2,
      'title': 'Essential Pet Vaccinations',
      'content': 'Vaccinations are crucial for your pet\'s health. Learn about the essential vaccines every pet needs to stay healthy and protected from common diseases.',
      'category': 'Health',
      'tags': 'vaccination,health,prevention',
      'image_url': 'assets/images/dog1.jpg',
      'published': 1,
      'likes_count': 45,
      'comments_count': 12,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });

    await db.insert('blog_posts', {
      'author_id': 2,
      'title': 'Basic Dog Training Tips',
      'content': 'Training your dog is essential for creating a well-behaved, happy companion. Here are fundamental training techniques that every dog owner should master.',
      'category': 'Training',
      'tags': 'training,dog,behavior,obedience',
      'image_url': 'assets/images/dog2.jpg',
      'published': 1,
      'likes_count': 38,
      'comments_count': 8,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });

    await db.insert('blog_posts', {
      'author_id': 1,
      'title': 'Nutritional Needs for Different Dog Breeds',
      'content': 'Different dog breeds have different nutritional requirements. Learn how to choose the right food for your specific breed and their unique needs.',
      'category': 'Nutrition',
      'tags': 'nutrition,dog food,breeds,health',
      'image_url': 'assets/images/pet1.jpg',
      'published': 1,
      'likes_count': 52,
      'comments_count': 15,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });

    await db.insert('blog_posts', {
      'author_id': 2,
      'title': 'Grooming Your Cat: A Complete Guide',
      'content': 'Regular grooming is essential for your cat\'s health and well-being. Learn the proper techniques for brushing, bathing, and nail trimming.',
      'category': 'Grooming',
      'tags': 'grooming,cat,hygiene,care',
      'image_url': 'assets/images/pet2.jpg',
      'published': 1,
      'likes_count': 29,
      'comments_count': 6,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });

    await db.insert('blog_posts', {
      'author_id': 1,
      'title': 'Understanding Pet Behavior: Signs to Watch For',
      'content': 'Learn to read your pet\'s body language and understand their behavior patterns. This knowledge will help you provide better care and strengthen your bond.',
      'category': 'Behavior',
      'tags': 'behavior,communication,pets,understanding',
      'image_url': 'assets/images/pet3.jpg',
      'published': 1,
      'likes_count': 67,
      'comments_count': 18,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });

    await db.insert('blog_posts', {
      'author_id': 2,
      'title': 'Creating a Pet-Friendly Home Environment',
      'content': 'Transform your home into a safe and comfortable space for your pets. Learn about pet-proofing, creating play areas, and choosing pet-friendly furniture.',
      'category': 'General',
      'tags': 'home,environment,safety,pets',
      'image_url': 'assets/images/dog1.jpg',
      'published': 1,
      'likes_count': 41,
      'comments_count': 9,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });

    // Additional blog posts with more variety
    await db.insert('blog_posts', {
      'author_id': 1,
      'title': 'First Aid for Pets: Essential Emergency Care',
      'content': 'Learn the basics of pet first aid to handle emergencies until you can reach a veterinarian. This knowledge could save your pet\'s life in critical situations.',
      'category': 'Health',
      'tags': 'first aid,emergency,health,safety',
      'image_url': 'assets/images/pet1.jpg',
      'published': 1,
      'likes_count': 89,
      'comments_count': 23,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });

    await db.insert('blog_posts', {
      'author_id': 2,
      'title': 'Advanced Dog Training Techniques',
      'content': 'Take your dog training to the next level with advanced techniques for complex commands, behavioral modification, and specialized training programs.',
      'category': 'Training',
      'tags': 'training,advanced,dog,behavior',
      'image_url': 'assets/images/dog2.jpg',
      'published': 1,
      'likes_count': 34,
      'comments_count': 7,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });

    await db.insert('blog_posts', {
      'author_id': 1,
      'title': 'Cat Nutrition: What Every Owner Should Know',
      'content': 'Understanding your cat\'s nutritional needs is crucial for their health and longevity. Learn about proper feeding schedules, portion control, and dietary requirements.',
      'category': 'Nutrition',
      'tags': 'nutrition,cat,feeding,health',
      'image_url': 'assets/images/pet2.jpg',
      'published': 1,
      'likes_count': 56,
      'comments_count': 14,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });

    await db.insert('blog_posts', {
      'author_id': 2,
      'title': 'Professional Grooming Tips for Dogs',
      'content': 'Master the art of dog grooming with professional techniques for bathing, brushing, nail trimming, and maintaining your dog\'s coat health.',
      'category': 'Grooming',
      'tags': 'grooming,dog,professional,care',
      'image_url': 'assets/images/dog3.jpg',
      'published': 1,
      'likes_count': 43,
      'comments_count': 11,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });

    await db.insert('blog_posts', {
      'author_id': 1,
      'title': 'Understanding Pet Anxiety and Stress',
      'content': 'Learn to recognize signs of anxiety and stress in your pets, and discover effective methods to help them feel more comfortable and secure.',
      'category': 'Behavior',
      'tags': 'anxiety,stress,behavior,mental health',
      'image_url': 'assets/images/pet3.jpg',
      'published': 1,
      'likes_count': 72,
      'comments_count': 19,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });

    await db.insert('blog_posts', {
      'author_id': 2,
      'title': 'Exercise Routines for Indoor Cats',
      'content': 'Keep your indoor cat active and healthy with creative exercise routines, interactive toys, and environmental enrichment strategies.',
      'category': 'Health',
      'tags': 'exercise,cat,indoor,activity',
      'image_url': 'assets/images/pet4.jpg',
      'published': 1,
      'likes_count': 31,
      'comments_count': 5,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });

    await db.insert('blog_posts', {
      'author_id': 1,
      'title': 'Puppy Socialization: The Critical First Months',
      'content': 'Proper socialization during your puppy\'s first few months is essential for their development. Learn the best practices for introducing them to new experiences.',
      'category': 'Training',
      'tags': 'puppy,socialization,training,development',
      'image_url': 'assets/images/pet5.jpg',
      'published': 1,
      'likes_count': 48,
      'comments_count': 13,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });

    await db.insert('blog_posts', {
      'author_id': 2,
      'title': 'Senior Pet Care: Special Considerations',
      'content': 'As pets age, their care needs change. Learn about special considerations for senior pets including diet, exercise, and health monitoring.',
      'category': 'Health',
      'tags': 'senior,aging,care,health',
      'image_url': 'assets/images/pet6.jpg',
      'published': 1,
      'likes_count': 63,
      'comments_count': 16,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });

    await db.insert('blog_posts', {
      'author_id': 1,
      'title': 'Traveling with Pets: A Complete Guide',
      'content': 'Make traveling with your pet stress-free with our comprehensive guide covering preparation, safety tips, and destination considerations.',
      'category': 'General',
      'tags': 'travel,pets,safety,preparation',
      'image_url': 'assets/images/pet7.jpg',
      'published': 1,
      'likes_count': 37,
      'comments_count': 8,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });

    // Additional Pet Care Blog Posts
    await db.insert('blog_posts', {
      'author_id': 1,
      'title': 'Essential Grooming Tips for Your Dog',
      'content': 'Learn the fundamentals of dog grooming including brushing techniques, nail trimming, ear cleaning, and dental care. Regular grooming not only keeps your dog looking great but also promotes good health and strengthens your bond.',
      'category': 'Grooming',
      'tags': 'grooming,dog care,health,hygiene',
      'image_url': 'assets/images/pet2.jpg',
      'published': 1,
      'likes_count': 124,
      'comments_count': 31,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });

    await db.insert('blog_posts', {
      'author_id': 1,
      'title': 'Understanding Your Cat\'s Behavior',
      'content': 'Decode the mysterious world of feline behavior! From purring and kneading to hiding and scratching, learn what your cat is trying to tell you and how to respond appropriately to their needs.',
      'category': 'Behavior',
      'tags': 'cat behavior,communication,pets,understanding',
      'image_url': 'assets/images/pet3.jpg',
      'published': 1,
      'likes_count': 89,
      'comments_count': 22,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });

    await db.insert('blog_posts', {
      'author_id': 1,
      'title': 'Creating a Pet-Friendly Home Environment',
      'content': 'Transform your home into a safe and comfortable haven for your pets. Learn about pet-proofing, creating designated spaces, choosing pet-safe plants, and organizing your home for optimal pet happiness.',
      'category': 'Environment',
      'tags': 'home,pet safety,environment,organization',
      'image_url': 'assets/images/pet4.jpg',
      'published': 1,
      'likes_count': 156,
      'comments_count': 45,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });

    await db.insert('blog_posts', {
      'author_id': 1,
      'title': 'Nutrition Guide for Senior Pets',
      'content': 'As pets age, their nutritional needs change significantly. Discover the best diet options, supplements, and feeding schedules for senior dogs and cats to ensure they maintain optimal health in their golden years.',
      'category': 'Nutrition',
      'tags': 'senior pets,nutrition,diet,health,aging',
      'image_url': 'assets/images/pet5.jpg',
      'published': 1,
      'likes_count': 98,
      'comments_count': 28,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });

    await db.insert('blog_posts', {
      'author_id': 1,
      'title': 'Training Your Puppy: The First 6 Months',
      'content': 'Master the art of puppy training with our comprehensive guide covering house training, basic commands, socialization, and behavior management. Set your puppy up for a lifetime of good behavior and happiness.',
      'category': 'Training',
      'tags': 'puppy training,obedience,socialization,behavior',
      'image_url': 'assets/images/pet6.jpg',
      'published': 1,
      'likes_count': 203,
      'comments_count': 67,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });

    await db.insert('blog_posts', {
      'author_id': 1,
      'title': 'Mental Stimulation Games for Indoor Cats',
      'content': 'Keep your indoor cat mentally sharp and physically active with these engaging games and activities. From puzzle feeders to interactive toys, discover creative ways to enrich your cat\'s daily routine.',
      'category': 'Enrichment',
      'tags': 'indoor cats,mental stimulation,games,enrichment',
      'image_url': 'assets/images/pet8.jpg',
      'published': 1,
      'likes_count': 142,
      'comments_count': 39,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });

    await db.insert('blog_posts', {
      'author_id': 1,
      'title': 'Recognizing Signs of Pet Stress and Anxiety',
      'content': 'Learn to identify the subtle and not-so-subtle signs of stress and anxiety in your pets. Understanding these signals is crucial for providing timely support and creating a calm, comfortable environment for your furry friends.',
      'category': 'Health',
      'tags': 'stress,anxiety,pet health,behavior,signs',
      'image_url': 'assets/images/pet9.jpg',
      'published': 1,
      'likes_count': 167,
      'comments_count': 52,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });

    // Insert sample products
    await db.insert('products', {
      'name': 'Premium Dog Food',
      'description': 'Nutritionally balanced dog food',
      'price': 49.99,
      'category': 'Food',
      'image_url': 'assets/images/pfood1-removebg-preview.png',
      'external_url': 'https://example-store.com/dog-food',
      'brand': 'NutriPaws',
      'stock': 50,
      'rating': 4.5,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });
  }

  // Helper methods for common operations
  Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert(table, data);
  }

  Future<List<Map<String, dynamic>>> query(String table, {String? where, List<dynamic>? whereArgs}) async {
    final db = await database;
    return await db.query(table, where: where, whereArgs: whereArgs);
  }

  Future<int> update(String table, Map<String, dynamic> data, {String? where, List<dynamic>? whereArgs}) async {
    final db = await database;
    return await db.update(table, data, where: where, whereArgs: whereArgs);
  }

  Future<int> delete(String table, {String? where, List<dynamic>? whereArgs}) async {
    final db = await database;
    return await db.delete(table, where: where, whereArgs: whereArgs);
  }

  Future close() async {
    final db = await database;
    db.close();
  }

  // Review methods
  Future<void> insertReview(Map<String, dynamic> reviewData) async {
    final db = await database;
    await db.insert('product_reviews', reviewData);
  }

  Future<List<Map<String, dynamic>>> getReviewsForProduct(String productId) async {
    final db = await database;
    return await db.query(
      'product_reviews',
      where: 'product_id = ?',
      whereArgs: [productId],
      orderBy: 'created_at DESC',
    );
  }

  Future<void> updateReview(Map<String, dynamic> reviewData) async {
    final db = await database;
    await db.update(
      'product_reviews',
      reviewData,
      where: 'id = ?',
      whereArgs: [reviewData['id']],
    );
  }

  Future<void> deleteReview(String reviewId) async {
    final db = await database;
    await db.delete(
      'product_reviews',
      where: 'id = ?',
      whereArgs: [reviewId],
    );
  }

  Future<double> getAverageRatingForProduct(String productId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT AVG(rating) as avg_rating FROM product_reviews WHERE product_id = ?',
      [productId],
    );
    return (result.first['avg_rating'] as double?) ?? 0.0;
  }

  Future<int> getReviewCountForProduct(String productId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM product_reviews WHERE product_id = ?',
      [productId],
    );
    return result.first['count'] as int;
  }

  // User Management Methods
  Future<int> insertUser(Map<String, dynamic> userData) async {
    final db = await database;
    return await db.insert('users', userData);
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<Map<String, dynamic>?> getUserById(int userId) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<void> updateUser(int userId, Map<String, dynamic> userData) async {
    final db = await database;
    await db.update(
      'users',
      userData,
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  // Cart Management Methods
  Future<void> addToCart(int userId, String productId, int quantity) async {
    final db = await database;
    
    // Check if item already exists in cart
    final existing = await db.query(
      'cart',
      where: 'user_id = ? AND product_id = ?',
      whereArgs: [userId, productId],
    );
    
    if (existing.isNotEmpty) {
      // Update quantity
      await db.update(
        'cart',
        {
          'quantity': (existing.first['quantity'] as int) + quantity,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'user_id = ? AND product_id = ?',
        whereArgs: [userId, productId],
      );
    } else {
      // Add new item
      await db.insert('cart', {
        'user_id': userId,
        'product_id': productId,
        'quantity': quantity,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });
    }
  }

  Future<List<Map<String, dynamic>>> getCartItems(int userId) async {
    final db = await database;
    return await db.query(
      'cart',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );
  }

  Future<void> removeFromCart(int userId, String productId) async {
    final db = await database;
    await db.delete(
      'cart',
      where: 'user_id = ? AND product_id = ?',
      whereArgs: [userId, productId],
    );
  }

  Future<void> clearCart(int userId) async {
    final db = await database;
    await db.delete(
      'cart',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  // Order Management Methods
  Future<int> createOrder(Map<String, dynamic> orderData) async {
    final db = await database;
    return await db.insert('orders', orderData);
  }

  Future<void> addOrderItem(Map<String, dynamic> orderItemData) async {
    final db = await database;
    await db.insert('order_items', orderItemData);
  }

  Future<List<Map<String, dynamic>>> getUserOrders(int userId) async {
    final db = await database;
    return await db.query(
      'orders',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );
  }

  Future<List<Map<String, dynamic>>> getOrderItems(int orderId) async {
    final db = await database;
    return await db.query(
      'order_items',
      where: 'order_id = ?',
      whereArgs: [orderId],
    );
  }

  // Payment Information Methods
  Future<void> savePaymentInfo(Map<String, dynamic> paymentData) async {
    final db = await database;
    await db.insert('payment_info', paymentData);
  }

  Future<List<Map<String, dynamic>>> getUserPaymentInfo(int userId) async {
    final db = await database;
    return await db.query(
      'payment_info',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'is_default DESC, created_at DESC',
    );
  }

  // Shipping Address Methods
  Future<void> saveShippingAddress(Map<String, dynamic> addressData) async {
    final db = await database;
    await db.insert('shipping_addresses', addressData);
  }

  Future<List<Map<String, dynamic>>> getUserShippingAddresses(int userId) async {
    final db = await database;
    return await db.query(
      'shipping_addresses',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'is_default DESC, created_at DESC',
    );
  }

  Future<void> setDefaultShippingAddress(int userId, int addressId) async {
    final db = await database;
    
    // Remove default from all addresses
    await db.update(
      'shipping_addresses',
      {'is_default': 0},
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    
    // Set new default
    await db.update(
      'shipping_addresses',
      {'is_default': 1},
      where: 'id = ? AND user_id = ?',
      whereArgs: [addressId, userId],
    );
  }
}

