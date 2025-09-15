import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pawfect_care/core/theme/app_theme.dart';
import 'package:pawfect_care/core/services/auth_service.dart';
import 'package:pawfect_care/core/services/user_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _userService = UserService();
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final user = _userService.currentUser;
    if (user != null) {
      setState(() {
        _userData = user;
      });
    }
  }

  String _getUserDisplayName() {
    if (_userData != null) {
      return _userData!['name'] ?? 'User';
    }
    return 'User';
  }

  String _getUserEmail() {
    if (_userData != null) {
      return _userData!['email'] ?? 'user@example.com';
    }
    return 'user@example.com';
  }

  String _getUserPhone() {
    if (_userData != null) {
      return _userData!['phone'] ?? '+1 (555) 000-0000';
    }
    return '+1 (555) 000-0000';
  }

  String _getUserRole() {
    if (_userData != null) {
      final role = _userData!['role'] ?? 'pet_owner';
      switch (role) {
        case 'pet_owner':
          return 'Pet Owner';
        case 'veterinarian':
          return 'Veterinarian';
        case 'shelter_admin':
          return 'Shelter Administrator';
        default:
          return 'User';
      }
    }
    return 'User';
  }

  IconData _getUserRoleIcon() {
    if (_userData != null) {
      final role = _userData!['role'] ?? 'pet_owner';
      switch (role) {
        case 'pet_owner':
          return Iconsax.pet;
        case 'veterinarian':
          return Iconsax.health;
        case 'shelter_admin':
          return Iconsax.home;
        default:
          return Iconsax.user;
      }
    }
    return Iconsax.user;
  }

  Color _getUserRoleColor() {
    if (_userData != null) {
      final role = _userData!['role'] ?? 'pet_owner';
      switch (role) {
        case 'pet_owner':
          return AppTheme.primaryColor;
        case 'veterinarian':
          return Colors.green;
        case 'shelter_admin':
          return Colors.orange;
        default:
          return AppTheme.primaryColor;
      }
    }
    return AppTheme.primaryColor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: _getUserRoleColor().withOpacity(0.1),
                    child: Icon(
                      _getUserRoleIcon(),
                      size: 50,
                      color: _getUserRoleColor(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _getUserDisplayName(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getUserRoleColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _getUserRoleColor().withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      _getUserRole(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _getUserRoleColor(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getUserEmail(),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getUserPhone(),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Profile Options
            _buildProfileOption(
              icon: Iconsax.user_edit,
              title: 'Edit Profile',
              onTap: () => context.go('/edit-profile'),
            ),
            _buildProfileOption(
              icon: Iconsax.setting_2,
              title: 'Settings',
              onTap: () => context.go('/settings'),
            ),
            _buildProfileOption(
              icon: Iconsax.notification,
              title: 'Notifications',
              onTap: () => context.go('/notification-settings'),
            ),
            _buildProfileOption(
              icon: Iconsax.shield_tick,
              title: 'Privacy & Security',
              onTap: () => context.go('/privacy-security'),
            ),
            _buildProfileOption(
              icon: Iconsax.message_question,
              title: 'Help & Support',
              onTap: () => context.go('/support'),
            ),
            _buildProfileOption(
              icon: Iconsax.user_edit,
              title: 'Change Role',
              onTap: () => context.go('/role-selection'),
            ),
            _buildProfileOption(
              icon: Iconsax.logout,
              title: 'Logout',
              onTap: () => _showLogoutDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: AppTheme.primaryColor,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(
          Iconsax.arrow_right_3,
          color: Colors.grey,
        ),
        onTap: onTap,
      ),
    );
  }

  void _showAchievements(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Iconsax.crown, color: Colors.amber),
            SizedBox(width: 8),
            Text('Your Achievements'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.amber,
                child: Icon(Iconsax.crown, color: Colors.white),
              ),
              title: Text('First Pet Added'),
              subtitle: Text('Added your first pet to the app'),
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(Iconsax.calendar, color: Colors.white),
              ),
              title: Text('First Appointment'),
              subtitle: Text('Booked your first veterinary appointment'),
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.green,
                child: Icon(Iconsax.shopping_bag, color: Colors.white),
              ),
              title: Text('First Purchase'),
              subtitle: Text('Made your first purchase in the shop'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showBadges(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Iconsax.medal, color: Colors.purple),
            SizedBox(width: 8),
            Text('Your Badges'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.green,
                child: Icon(Iconsax.heart, color: Colors.white),
              ),
              title: Text('Pet Lover'),
              subtitle: Text('You care deeply for your pets'),
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(Iconsax.document_text, color: Colors.white),
              ),
              title: Text('Blog Reader'),
              subtitle: Text('Read 10+ pet care articles'),
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.orange,
                child: Icon(Iconsax.calendar_1, color: Colors.white),
              ),
              title: Text('Health Conscious'),
              subtitle: Text('Regular veterinary checkups'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _performLogout(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _performLogout(BuildContext context) async {
    try {
      // Show loading indicator
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                SizedBox(width: 16),
                Text('Logging out...'),
              ],
            ),
            duration: Duration(seconds: 30), // Longer duration to prevent stuck message
            backgroundColor: Colors.orange,
          ),
        );
      }

      // Clear user session
      final authService = AuthService();
      await authService.logout();

      // Navigate to login screen immediately after logout
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        context.go('/login');
      }
    } catch (e) {
      // Show error message
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout failed: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}
