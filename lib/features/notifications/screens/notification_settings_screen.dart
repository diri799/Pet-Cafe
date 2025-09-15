import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pawfect_care/core/theme/app_theme.dart';
import 'package:pawfect_care/core/services/notification_service.dart';
import 'package:pawfect_care/core/services/firebase_auth_service.dart';
import 'package:pawfect_care/core/services/auth_service.dart';

class NotificationSettingsScreen extends ConsumerStatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  ConsumerState<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends ConsumerState<NotificationSettingsScreen> {
  // final NotificationService _notificationService = NotificationService();
  final FirebaseAuthService _authService = FirebaseAuthService();
  final AuthService _authService2 = AuthService();

  bool _newPets = true;
  bool _appointments = true;
  bool _blogUpdates = true;
  bool _emailNotifications = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadNotificationSettings();
  }

  Future<void> _loadNotificationSettings() async {
    setState(() => _isLoading = true);

    try {
      final user = _authService.currentUser;
      if (user != null) {
        // For web compatibility, use mock notification settings
        setState(() {
          _newPets = true;
          _appointments = true;
          _blogUpdates = true;
          _emailNotifications = true;
        });
      }
    } catch (e) {
      _showErrorSnackBar('Failed to load notification settings');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateNotificationSettings() async {
    setState(() => _isLoading = true);

    try {
      final user = _authService.currentUser;
      if (user != null) {
        // For web compatibility, simulate notification settings update
        await Future.delayed(
          const Duration(milliseconds: 500),
        ); // Simulate network delay

        _showSuccessSnackBar('Notification settings updated successfully');
      }
    } catch (e) {
      _showErrorSnackBar('Failed to update notification settings');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () async {
            // Navigate back to the previous screen
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              // If can't pop, go to role-specific dashboard
              final dashboardRoute = _authService2.getDashboardRoute();
              context.go(dashboardRoute);
            }
          },
          tooltip: 'Back',
        ),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
        ],
      ),
      body: _isLoading && _newPets == true && _appointments == true
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppTheme.primaryColor.withValues(alpha: 0.1),
                          AppTheme.primaryDark.withValues(alpha: 0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Iconsax.notification,
                          size: 48,
                          color: AppTheme.primaryColor,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Manage Your Notifications',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Choose what notifications you want to receive',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Push Notifications Section
                  _buildSectionHeader('Push Notifications'),
                  const SizedBox(height: 16),

                  _buildNotificationTile(
                    icon: Iconsax.pet,
                    title: 'New Pets Available',
                    subtitle:
                        'Get notified when new pets are available for adoption',
                    value: _newPets,
                    onChanged: (value) {
                      setState(() => _newPets = value);
                      _updateNotificationSettings();
                    },
                  ),

                  _buildNotificationTile(
                    icon: Iconsax.calendar,
                    title: 'Appointment Reminders',
                    subtitle: 'Receive reminders about upcoming appointments',
                    value: _appointments,
                    onChanged: (value) {
                      setState(() => _appointments = value);
                      _updateNotificationSettings();
                    },
                  ),

                  _buildNotificationTile(
                    icon: Iconsax.document_text,
                    title: 'Blog Updates',
                    subtitle: 'Get notified about new blog posts and articles',
                    value: _blogUpdates,
                    onChanged: (value) {
                      setState(() => _blogUpdates = value);
                      _updateNotificationSettings();
                    },
                  ),

                  const SizedBox(height: 24),

                  // Email Notifications Section
                  _buildSectionHeader('Email Notifications'),
                  const SizedBox(height: 16),

                  _buildNotificationTile(
                    icon: Iconsax.sms,
                    title: 'Email Notifications',
                    subtitle:
                        'Receive email notifications for important updates',
                    value: _emailNotifications,
                    onChanged: (value) {
                      setState(() => _emailNotifications = value);
                      _updateNotificationSettings();
                    },
                  ),

                  const SizedBox(height: 32),

                  // Test Notifications Button
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.blue.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Iconsax.notification_bing,
                          size: 32,
                          color: Colors.blue,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Test Notifications',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Send a test notification to verify your settings are working correctly',
                          style: TextStyle(fontSize: 14, color: Colors.blue),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: _isLoading ? null : _sendTestNotification,
                          icon: const Icon(Iconsax.send),
                          label: const Text('Send Test Notification'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Information Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Iconsax.info_circle,
                              size: 20,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'About Notifications',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '• Push notifications will appear on your device even when the app is closed\n'
                          '• Email notifications will be sent to your registered email address\n'
                          '• You can change these settings at any time\n'
                          '• Some notifications are essential for app functionality',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildNotificationTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SwitchListTile(
        secondary: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppTheme.primaryColor, size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: AppTheme.primaryColor,
      ),
    );
  }

  Future<void> _sendTestNotification() async {
    setState(() => _isLoading = true);

    try {
      final user = _authService.currentUser;
      if (user != null) {
        // For web compatibility, simulate push notification
        await Future.delayed(
          const Duration(milliseconds: 500),
        ); // Simulate network delay

        _showSuccessSnackBar('Test notification sent successfully!');
      }
    } catch (e) {
      _showErrorSnackBar('Failed to send test notification');
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
