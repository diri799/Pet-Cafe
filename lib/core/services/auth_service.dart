import 'package:pawfect_care/core/services/user_service.dart';

class AuthService {
  final UserService _userService = UserService();

  Future<bool> checkLoginStatus() async {
    return await _userService.checkLoginStatus();
  }

  Future<String> getUserRole() async {
    return await _userService.getUserRole();
  }

  Future<void> login(String email, String password, String role) async {
    final success = await _userService.login(email, password);
    if (!success) {
      throw Exception('Invalid email or password for the selected role');
    }

    // Verify the user's role matches the selected role
    final userRole = await _userService.getUserRole();
    if (userRole != role) {
      await _userService.logout(); // Clear the login session
      throw Exception(
        'Selected role does not match user credentials. Please select the correct role.',
      );
    }
  }

  Future<void> logout() async {
    await _userService.logout();
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String role,
  }) async {
    return await _userService.register(
      name: name,
      email: email,
      password: password,
      phone: phone,
      role: role,
    );
  }

  Future<String> getDashboardRouteAsync() async {
    return _userService.getDashboardRoute();
  }

  String getDashboardRoute() {
    return _userService.getDashboardRoute();
  }
}
