import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:pawfect_care/core/database/database_helper.dart';

class UserService {
  static const String _currentUserIdKey = 'current_user_id';
  static const String _isLoggedInKey = 'is_authenticated';
  static const String _userRoleKey = 'user_role';

  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Current user data
  Map<String, dynamic>? _currentUser;
  int? _currentUserId;

  // Getters
  Map<String, dynamic>? get currentUser => _currentUser;
  int? get currentUserId => _currentUserId;
  bool get isLoggedIn => _currentUserId != null;

  // Initialize user service
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();

    if (kIsWeb) {
      // For web platform, check if demo user exists, if not create one
      final existingEmail = prefs.getString('user_email');
      if (existingEmail == null) {
        await _createDemoUserForWeb();
      }

      // Check if user is already logged in
      final isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
      if (isLoggedIn) {
        _currentUser = {
          'name': prefs.getString('user_name') ?? 'Demo User',
          'email': prefs.getString('user_email') ?? 'demo@example.com',
          'phone': prefs.getString('user_phone') ?? '',
          'role': prefs.getString(_userRoleKey) ?? 'pet_owner',
        };
      }
      return;
    }

    // For desktop/mobile platform, use database
    // Create demo users if they don't exist
    await _createDemoUsersForDatabase();

    final userId = prefs.getInt(_currentUserIdKey);

    if (userId != null) {
      _currentUserId = userId;
      _currentUser = await _dbHelper.getUserById(userId);
    }
  }

  // Create demo user for web platform
  Future<void> _createDemoUserForWeb() async {
    final prefs = await SharedPreferences.getInstance();

    // Create demo users for each role
    await prefs.setString('demo_pet_owner_email', 'john@example.com');
    await prefs.setString('demo_pet_owner_password', 'password123');
    await prefs.setString('demo_pet_owner_name', 'John Doe');
    await prefs.setString('demo_pet_owner_phone', '+1234567890');

    await prefs.setString('demo_veterinarian_email', 'dr.sarah@vet.com');
    await prefs.setString('demo_veterinarian_password', 'vetpass123');
    await prefs.setString('demo_veterinarian_name', 'Dr. Sarah Wilson');
    await prefs.setString('demo_veterinarian_phone', '+1234567891');

    await prefs.setString('demo_shelter_admin_email', 'admin@shelter.com');
    await prefs.setString('demo_shelter_admin_password', 'shelterpass123');
    await prefs.setString('demo_shelter_admin_name', 'Happy Paws Shelter');
    await prefs.setString('demo_shelter_admin_phone', '+1234567892');
  }

  // Create demo users for database platform
  Future<void> _createDemoUsersForDatabase() async {
    try {
      // Check if demo users already exist
      final petOwner = await _dbHelper.getUserByEmail('john@example.com');
      if (petOwner == null) {
        await _dbHelper.insertUser({
          'name': 'John Doe',
          'email': 'john@example.com',
          'password': 'password123',
          'phone': '+1234567890',
          'role': 'pet_owner',
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        });
      }

      final veterinarian = await _dbHelper.getUserByEmail('dr.sarah@vet.com');
      if (veterinarian == null) {
        await _dbHelper.insertUser({
          'name': 'Dr. Sarah Wilson',
          'email': 'dr.sarah@vet.com',
          'password': 'vetpass123',
          'phone': '+1234567891',
          'role': 'veterinarian',
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        });
      }

      final shelterAdmin = await _dbHelper.getUserByEmail('admin@shelter.com');
      if (shelterAdmin == null) {
        await _dbHelper.insertUser({
          'name': 'Happy Paws Shelter',
          'email': 'admin@shelter.com',
          'password': 'shelterpass123',
          'phone': '+1234567892',
          'role': 'shelter_admin',
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        });
      }
    } catch (e) {
      debugPrint('Failed to create demo users: $e');
    }
  }

  // Login with email and password
  Future<bool> login(String email, String password) async {
    if (kIsWeb) {
      // For web platform, use SharedPreferences only
      final prefs = await SharedPreferences.getInstance();

      // Check demo credentials for each role
      String? role;
      String? name;
      String? phone;

      // Check pet owner credentials
      if (email == prefs.getString('demo_pet_owner_email') &&
          password == prefs.getString('demo_pet_owner_password')) {
        role = 'pet_owner';
        name = prefs.getString('demo_pet_owner_name');
        phone = prefs.getString('demo_pet_owner_phone');
      }
      // Check veterinarian credentials
      else if (email == prefs.getString('demo_veterinarian_email') &&
          password == prefs.getString('demo_veterinarian_password')) {
        role = 'veterinarian';
        name = prefs.getString('demo_veterinarian_name');
        phone = prefs.getString('demo_veterinarian_phone');
      }
      // Check shelter admin credentials
      else if (email == prefs.getString('demo_shelter_admin_email') &&
          password == prefs.getString('demo_shelter_admin_password')) {
        role = 'shelter_admin';
        name = prefs.getString('demo_shelter_admin_name');
        phone = prefs.getString('demo_shelter_admin_phone');
      }

      if (role != null) {
        // Save user data for current session
        await prefs.setString('user_name', name ?? 'User');
        await prefs.setString('user_email', email);
        await prefs.setString('user_phone', phone ?? '');
        await prefs.setString(_userRoleKey, role);
        await prefs.setBool(_isLoggedInKey, true);

        _currentUser = {
          'name': name ?? 'User',
          'email': email,
          'phone': phone ?? '',
          'role': role,
        };
        return true;
      }
      return false;
    }

    // For mobile platform, use database
    final user = await _dbHelper.getUserByEmail(email);

    if (user != null && user['password'] == password) {
      _currentUserId = user['id'];
      _currentUser = user;

      // Save to SharedPreferences for persistence
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_currentUserIdKey, _currentUserId!);
      await prefs.setBool(_isLoggedInKey, true);
      await prefs.setString(_userRoleKey, user['role']);

      return true;
    }

    return false;
  }

  // Register new user
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String role,
  }) async {
    if (kIsWeb) {
      // For web platform, use SharedPreferences only
      final prefs = await SharedPreferences.getInstance();
      final existingEmail = prefs.getString('user_email');

      if (existingEmail == email) {
        return false; // Email already exists
      }

      // Save user data
      await prefs.setString('user_name', name);
      await prefs.setString('user_email', email);
      await prefs.setString('user_password', password);
      await prefs.setString('user_phone', phone);
      await prefs.setString(_userRoleKey, role);
      await prefs.setBool(_isLoggedInKey, true);

      _currentUser = {
        'name': name,
        'email': email,
        'phone': phone,
        'role': role,
      };

      return true;
    }

    // For mobile platform, use database
    final existingUser = await _dbHelper.getUserByEmail(email);

    if (existingUser != null) {
      return false; // Email already exists
    }

    final userData = {
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'role': role,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };

    final userId = await _dbHelper.insertUser(userData);

    if (userId > 0) {
      _currentUserId = userId;
      _currentUser = {...userData, 'id': userId};

      // Save to SharedPreferences for persistence
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_currentUserIdKey, _currentUserId!);
      await prefs.setBool(_isLoggedInKey, true);
      await prefs.setString(_userRoleKey, role);

      return true;
    }

    return false;
  }

  // Logout
  Future<void> logout() async {
    _currentUser = null;
    _currentUserId = null;

    final prefs = await SharedPreferences.getInstance();

    if (kIsWeb) {
      // For web platform, clear all user-related data
      await prefs.remove(_currentUserIdKey);
      await prefs.setBool(_isLoggedInKey, false);
      await prefs.remove(_userRoleKey);
      await prefs.remove('user_name');
      await prefs.remove('user_email');
      await prefs.remove('user_phone');
      await prefs.remove('user_password');
    } else {
      // For mobile platform, clear session data
      await prefs.remove(_currentUserIdKey);
      await prefs.setBool(_isLoggedInKey, false);
      await prefs.remove(_userRoleKey);
    }
  }

  // Update user profile
  Future<bool> updateProfile({String? name, String? phone}) async {
    if (_currentUserId == null) return false;

    if (kIsWeb) {
      // For web platform, update SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      if (name != null) {
        await prefs.setString('user_name', name);
        _currentUser?['name'] = name;
      }
      if (phone != null) {
        await prefs.setString('user_phone', phone);
        _currentUser?['phone'] = phone;
      }
      return true;
    }

    // For mobile platform, update database
    final updateData = <String, dynamic>{
      'updated_at': DateTime.now().toIso8601String(),
    };

    if (name != null) updateData['name'] = name;
    if (phone != null) updateData['phone'] = phone;

    await _dbHelper.updateUser(_currentUserId!, updateData);

    // Update local user data
    if (name != null) _currentUser?['name'] = name;
    if (phone != null) _currentUser?['phone'] = phone;

    return true;
  }

  // Cart management
  Future<void> addToCart(String productId, int quantity) async {
    if (_currentUserId == null) return;

    if (kIsWeb) {
      // For web platform, use SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final cartKey = 'cart_${_currentUser?['email']}';
      final cartData = prefs.getStringList(cartKey) ?? [];

      // Simple cart storage for web (productId:quantity format)
      final existingIndex = cartData.indexWhere(
        (item) => item.startsWith('$productId:'),
      );
      if (existingIndex != -1) {
        final parts = cartData[existingIndex].split(':');
        final currentQuantity = int.tryParse(parts[1]) ?? 0;
        cartData[existingIndex] = '$productId:${currentQuantity + quantity}';
      } else {
        cartData.add('$productId:$quantity');
      }

      await prefs.setStringList(cartKey, cartData);
    } else {
      // For mobile platform, use database
      await _dbHelper.addToCart(_currentUserId!, productId, quantity);
    }
  }

  Future<List<Map<String, dynamic>>> getCartItems() async {
    if (_currentUserId == null) return [];

    if (kIsWeb) {
      // For web platform, get from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final cartKey = 'cart_${_currentUser?['email']}';
      final cartData = prefs.getStringList(cartKey) ?? [];

      return cartData.map((item) {
        final parts = item.split(':');
        return {
          'product_id': parts[0],
          'quantity': int.tryParse(parts[1]) ?? 1,
        };
      }).toList();
    } else {
      // For mobile platform, get from database
      return await _dbHelper.getCartItems(_currentUserId!);
    }
  }

  Future<void> removeFromCart(String productId) async {
    if (_currentUserId == null) return;

    if (kIsWeb) {
      // For web platform, update SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final cartKey = 'cart_${_currentUser?['email']}';
      final cartData = prefs.getStringList(cartKey) ?? [];

      cartData.removeWhere((item) => item.startsWith('$productId:'));
      await prefs.setStringList(cartKey, cartData);
    } else {
      // For mobile platform, update database
      await _dbHelper.removeFromCart(_currentUserId!, productId);
    }
  }

  Future<void> clearCart() async {
    if (_currentUserId == null) return;

    if (kIsWeb) {
      // For web platform, clear SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final cartKey = 'cart_${_currentUser?['email']}';
      await prefs.remove(cartKey);
    } else {
      // For mobile platform, clear database
      await _dbHelper.clearCart(_currentUserId!);
    }
  }

  // Get user orders
  Future<List<Map<String, dynamic>>> getUserOrders() async {
    if (_currentUserId == null) return [];

    if (kIsWeb) {
      // For web platform, get from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final ordersKey = 'orders_${_currentUser?['email']}';
      final ordersData = prefs.getStringList(ordersKey) ?? [];

      // Simple order storage for web (JSON strings)
      return ordersData.map((orderJson) {
        // This is a simplified version - in a real app you'd parse JSON
        return {'id': 1, 'status': 'delivered', 'total_amount': 99.99};
      }).toList();
    } else {
      // For mobile platform, get from database
      return await _dbHelper.getUserOrders(_currentUserId!);
    }
  }

  // Get user's adopted pets
  Future<List<Map<String, dynamic>>> getUserPets() async {
    if (_currentUserId == null) return [];

    if (kIsWeb) {
      // For web platform, get from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final petsKey = 'pets_${_currentUser?['email']}';
      final petsData = prefs.getStringList(petsKey) ?? [];

      // Simple pet storage for web
      return petsData.map((petJson) {
        // This is a simplified version - in a real app you'd parse JSON
        return {
          'id': 1,
          'name': 'Buddy',
          'species': 'Dog',
          'breed': 'Golden Retriever',
        };
      }).toList();
    } else {
      // For mobile platform, get from database
      return await _dbHelper.query(
        'pets',
        where: 'user_id = ?',
        whereArgs: [_currentUserId],
      );
    }
  }

  // Check if user is logged in
  Future<bool> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // Get user role
  Future<String> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userRoleKey) ?? 'pet_owner';
  }

  // Pet management methods
  Future<List<Map<String, dynamic>>> getPets() async {
    return await getUserPets();
  }

  Future<void> addPet(Map<String, dynamic> petData) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      final petsKey = 'pets_${_currentUser?['email']}';
      final petsData = prefs.getStringList(petsKey) ?? [];
      petsData.add('pet_${DateTime.now().millisecondsSinceEpoch}');
      await prefs.setStringList(petsKey, petsData);
    } else {
      await _dbHelper.insert('pets', petData);
    }
  }

  Future<void> updatePet(String petId, Map<String, dynamic> petData) async {
    if (kIsWeb) {
      // For web, we'll handle this in the UI layer
      return;
    } else {
      await _dbHelper.update(
        'pets',
        petData,
        where: 'id = ?',
        whereArgs: [petId],
      );
    }
  }

  Future<void> deletePet(String petId) async {
    if (kIsWeb) {
      // For web, we'll handle this in the UI layer
      return;
    } else {
      await _dbHelper.delete('pets', where: 'id = ?', whereArgs: [petId]);
    }
  }

  // Health records methods
  Future<List<Map<String, dynamic>>> getHealthRecords(String petId) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      final recordsKey = 'health_records_${petId}';
      final recordsData = prefs.getStringList(recordsKey) ?? [];
      return recordsData.map((recordJson) {
        // Simplified version - in real app parse JSON
        return {
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'pet_id': petId,
          'type': 'vaccination',
          'title': 'Rabies Vaccine',
          'date': DateTime.now().toIso8601String(),
        };
      }).toList();
    } else {
      return await _dbHelper.query(
        'health_records',
        where: 'pet_id = ?',
        whereArgs: [petId],
      );
    }
  }

  Future<void> addHealthRecord(
    String petId,
    Map<String, dynamic> recordData,
  ) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      final recordsKey = 'health_records_${petId}';
      final recordsData = prefs.getStringList(recordsKey) ?? [];
      recordsData.add('record_${DateTime.now().millisecondsSinceEpoch}');
      await prefs.setStringList(recordsKey, recordsData);
    } else {
      await _dbHelper.insert('health_records', recordData);
    }
  }

  // Appointment methods
  Future<List<Map<String, dynamic>>> getAppointments() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      final appointmentsKey = 'appointments_${_currentUser?['email']}';
      final appointmentsData = prefs.getStringList(appointmentsKey) ?? [];
      return appointmentsData.map((appointmentJson) {
        // Simplified version - in real app parse JSON
        return {
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'pet_id': 'pet_1',
          'type': 'checkup',
          'scheduled_date': DateTime.now()
              .add(const Duration(days: 7))
              .toIso8601String(),
          'reason': 'Regular checkup',
          'status': 'pending',
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        };
      }).toList();
    } else {
      return await _dbHelper.query(
        'appointments',
        where: 'pet_owner_id = ?',
        whereArgs: [_currentUserId],
      );
    }
  }

  Future<void> addAppointment(Map<String, dynamic> appointmentData) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      final appointmentsKey = 'appointments_${_currentUser?['email']}';
      final appointmentsData = prefs.getStringList(appointmentsKey) ?? [];
      appointmentsData.add(
        'appointment_${DateTime.now().millisecondsSinceEpoch}',
      );
      await prefs.setStringList(appointmentsKey, appointmentsData);
    } else {
      await _dbHelper.insert('appointments', appointmentData);
    }
  }

  Future<void> updateAppointment(
    String appointmentId,
    Map<String, dynamic> appointmentData,
  ) async {
    if (kIsWeb) {
      // For web, we'll handle this in the UI layer
      return;
    } else {
      await _dbHelper.update(
        'appointments',
        appointmentData,
        where: 'id = ?',
        whereArgs: [appointmentId],
      );
    }
  }

  Future<void> cancelAppointment(String appointmentId) async {
    if (kIsWeb) {
      // For web, we'll handle this in the UI layer
      return;
    } else {
      await _dbHelper.update(
        'appointments',
        {'status': 'cancelled'},
        where: 'id = ?',
        whereArgs: [appointmentId],
      );
    }
  }

  // Get dashboard route based on role
  String getDashboardRoute() {
    final role = _currentUser?['role'] ?? 'pet_owner';
    switch (role) {
      case 'veterinarian':
        return '/vet-dashboard';
      case 'shelter_admin':
        return '/shelter-dashboard';
      default:
        return '/home';
    }
  }
}
