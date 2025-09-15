import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  late Dio _dio;
  String? _accessToken;
  String? _refreshToken;
  String _baseUrl = 'http://localhost:8000/api/v1';

  void initialize() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3),
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (_accessToken != null) {
            options.headers['Authorization'] = 'Bearer $_accessToken';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            // Try to refresh token
            if (await _refreshAccessToken()) {
              // Retry the request
              final options = error.requestOptions;
              options.headers['Authorization'] = 'Bearer $_accessToken';
              final response = await _dio.fetch(options);
              handler.resolve(response);
              return;
            }
          }
          handler.next(error);
        },
      ),
    );
  }

  Future<bool> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      _accessToken = response.data['access_token'];
      _refreshToken = response.data['refresh_token'];

      // Save tokens to local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', _accessToken!);
      await prefs.setString('refresh_token', _refreshToken!);

      return true;
    } catch (e) {
      debugPrint('Login error: $e');
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String role,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
          'phone': phone,
          'role': role,
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Registration error: $e');
      return false;
    }
  }

  Future<bool> _refreshAccessToken() async {
    try {
      final response = await _dio.post(
        '/auth/refresh',
        data: {'refresh_token': _refreshToken},
      );

      _accessToken = response.data['access_token'];
      _refreshToken = response.data['refresh_token'];

      // Save new tokens
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', _accessToken!);
      await prefs.setString('refresh_token', _refreshToken!);

      return true;
    } catch (e) {
      print('Token refresh error: $e');
      return false;
    }
  }

  Future<void> logout() async {
    _accessToken = null;
    _refreshToken = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final response = await _dio.get('/auth/me');
      return response.data;
    } catch (e) {
      print('Get current user error: $e');
      return null;
    }
  }

  // Pet management
  Future<List<Map<String, dynamic>>> getPets() async {
    try {
      final response = await _dio.get('/pets/');
      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      print('Get pets error: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> createPet(Map<String, dynamic> petData) async {
    try {
      final response = await _dio.post('/pets/', data: petData);
      return response.data;
    } catch (e) {
      print('Create pet error: $e');
      return null;
    }
  }

  // Appointments
  Future<List<Map<String, dynamic>>> getAppointments() async {
    try {
      final response = await _dio.get('/appointments/');
      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      print('Get appointments error: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> createAppointment(
    Map<String, dynamic> appointmentData,
  ) async {
    try {
      final response = await _dio.post('/appointments/', data: appointmentData);
      return response.data;
    } catch (e) {
      print('Create appointment error: $e');
      return null;
    }
  }

  // Products
  Future<List<Map<String, dynamic>>> getProducts() async {
    try {
      final response = await _dio.get('/products/');
      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      print('Get products error: $e');
      return [];
    }
  }

  // Blog posts
  Future<List<Map<String, dynamic>>> getBlogPosts() async {
    try {
      final response = await _dio.get('/blog/');
      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      print('Get blog posts error: $e');
      return [];
    }
  }

  // Shelter pets
  Future<List<Map<String, dynamic>>> getShelterPets() async {
    try {
      final response = await _dio.get('/shelters/pets');
      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      print('Get shelter pets error: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> createAdoptionRequest(
    Map<String, dynamic> requestData,
  ) async {
    try {
      final response = await _dio.post(
        '/shelters/adoption-requests',
        data: requestData,
      );
      return response.data;
    } catch (e) {
      print('Create adoption request error: $e');
      return null;
    }
  }

  // Load tokens from storage on app start
  Future<void> loadTokens() async {
    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString('access_token');
    _refreshToken = prefs.getString('refresh_token');
  }

  bool get isLoggedIn => _accessToken != null;
}
