import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseAuthService {
  static final FirebaseAuthService _instance = FirebaseAuthService._internal();
  factory FirebaseAuthService() => _instance;
  FirebaseAuthService._internal();

  // Current user
  Map<String, dynamic>? _currentUser;
  bool _isLoggedIn = false;

  Map<String, dynamic>? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;

  // Sign up with email and password
  Future<Map<String, dynamic>?> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String role,
  }) async {
    if (kIsWeb) {
      // For web platform, simulate sign up
      final userData = {
        'uid': 'user_${DateTime.now().millisecondsSinceEpoch}',
        'email': email,
        'name': name,
        'phone': phone,
        'role': role,
        'emailVerified': false,
      };

      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_email', email);
      await prefs.setString('user_password', password);
      await prefs.setString('user_name', name);
      await prefs.setString('user_phone', phone);
      await prefs.setString('user_role', role);
      await prefs.setBool('is_logged_in', true);

      _currentUser = userData;
      _isLoggedIn = true;

      return userData;
    }

    // For non-web platforms, you would implement Firebase logic here
    throw UnsupportedError(
      'FirebaseAuthService.signUpWithEmail is not implemented for non-web platforms',
    );
  }

  // Sign in with email and password
  Future<Map<String, dynamic>?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    if (kIsWeb) {
      // For web platform, simulate sign in
      final prefs = await SharedPreferences.getInstance();
      final storedEmail = prefs.getString('user_email');
      final storedPassword = prefs.getString('user_password');

      if (storedEmail == email && storedPassword == password) {
        final userData = {
          'uid': 'user_${DateTime.now().millisecondsSinceEpoch}',
          'email': email,
          'name': prefs.getString('user_name') ?? 'User',
          'phone': prefs.getString('user_phone') ?? '',
          'role': prefs.getString('user_role') ?? 'pet_owner',
          'emailVerified': true,
        };

        await prefs.setBool('is_logged_in', true);

        _currentUser = userData;
        _isLoggedIn = true;

        return userData;
      } else {
        throw Exception('Invalid email or password');
      }
    }

    // For non-web platforms, you would implement Firebase logic here
    throw UnsupportedError(
      'FirebaseAuthService.signInWithEmail is not implemented for non-web platforms',
    );
  }

  // Sign out
  Future<void> signOut() async {
    if (kIsWeb) {
      // For web platform, clear SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_logged_in', false);

      _currentUser = null;
      _isLoggedIn = false;

      return;
    }

    // For non-web platforms, you would implement Firebase logic here
    throw UnsupportedError(
      'FirebaseAuthService.signOut is not implemented for non-web platforms',
    );
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    if (kIsWeb) {
      // For web platform, simulate password reset
      print('Password reset email sent to $email');
      return;
    }

    // For non-web platforms, you would implement Firebase logic here
    throw UnsupportedError(
      'FirebaseAuthService.resetPassword is not implemented for non-web platforms',
    );
  }

  // Update user profile
  Future<void> updateUserProfile({String? name, String? phone}) async {
    if (kIsWeb) {
      // For web platform, update SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      if (name != null) {
        await prefs.setString('user_name', name);
      }
      if (phone != null) {
        await prefs.setString('user_phone', phone);
      }

      // Update current user data
      if (_currentUser != null) {
        if (name != null) _currentUser!['name'] = name;
        if (phone != null) _currentUser!['phone'] = phone;
      }

      return;
    }

    // For non-web platforms, you would implement Firebase logic here
    throw UnsupportedError(
      'FirebaseAuthService.updateUserProfile is not implemented for non-web platforms',
    );
  }

  // Check if user is logged in
  Future<bool> checkLoginStatus() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool('is_logged_in') ?? false;

      if (isLoggedIn) {
        _currentUser = {
          'uid': 'user_${DateTime.now().millisecondsSinceEpoch}',
          'email': prefs.getString('user_email') ?? '',
          'name': prefs.getString('user_name') ?? 'User',
          'phone': prefs.getString('user_phone') ?? '',
          'role': prefs.getString('user_role') ?? 'pet_owner',
          'emailVerified': true,
        };
        _isLoggedIn = true;
      }

      return isLoggedIn;
    }

    // For non-web platforms, you would implement Firebase logic here
    throw UnsupportedError(
      'FirebaseAuthService.checkLoginStatus is not implemented for non-web platforms',
    );
  }
}
