import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pawfect_care/core/theme/app_theme.dart';
import 'package:pawfect_care/core/services/auth_service.dart';

class PrivacySecurityScreen extends StatefulWidget {
  const PrivacySecurityScreen({super.key});

  @override
  State<PrivacySecurityScreen> createState() => _PrivacySecurityScreenState();
}

class _PrivacySecurityScreenState extends State<PrivacySecurityScreen> {
  final AuthService _authService = AuthService();
  bool _dataCollectionEnabled = true;
  bool _analyticsEnabled = true;
  bool _marketingEmailsEnabled = false;
  bool _twoFactorAuthEnabled = false;
  bool _biometricAuthEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy & Security'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_2),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              final dashboardRoute = _authService.getDashboardRoute();
              context.go(dashboardRoute);
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Privacy Settings
            _buildSettingsSection(
              title: 'Privacy Settings',
              children: [
                _buildSwitchTile(
                  icon: Iconsax.shield_tick,
                  title: 'Data Collection',
                  subtitle: 'Allow app to collect usage data for improvements',
                  value: _dataCollectionEnabled,
                  onChanged: (value) {
                    setState(() {
                      _dataCollectionEnabled = value;
                    });
                  },
                ),
                _buildSwitchTile(
                  icon: Iconsax.chart,
                  title: 'Analytics',
                  subtitle: 'Help us improve the app with anonymous usage data',
                  value: _analyticsEnabled,
                  onChanged: (value) {
                    setState(() {
                      _analyticsEnabled = value;
                    });
                  },
                ),
                _buildSwitchTile(
                  icon: Iconsax.sms,
                  title: 'Marketing Emails',
                  subtitle: 'Receive promotional emails and updates',
                  value: _marketingEmailsEnabled,
                  onChanged: (value) {
                    setState(() {
                      _marketingEmailsEnabled = value;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Security Settings
            _buildSettingsSection(
              title: 'Security Settings',
              children: [
                _buildListTile(
                  icon: Iconsax.key,
                  title: 'Change Password',
                  subtitle: 'Update your account password',
                  onTap: () => _showChangePasswordDialog(),
                ),
                _buildSwitchTile(
                  icon: Iconsax.security_user,
                  title: 'Two-Factor Authentication',
                  subtitle: 'Add an extra layer of security',
                  value: _twoFactorAuthEnabled,
                  onChanged: (value) {
                    setState(() {
                      _twoFactorAuthEnabled = value;
                    });
                    if (value) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Two-factor authentication enabled!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                ),
                _buildSwitchTile(
                  icon: Iconsax.finger_scan,
                  title: 'Biometric Authentication',
                  subtitle: 'Use fingerprint or face recognition',
                  value: _biometricAuthEnabled,
                  onChanged: (value) {
                    setState(() {
                      _biometricAuthEnabled = value;
                    });
                    if (value) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Biometric authentication enabled!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                ),
                _buildListTile(
                  icon: Iconsax.shield_cross,
                  title: 'Login Activity',
                  subtitle: 'View recent login attempts',
                  onTap: () => _showLoginActivity(),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Data Management
            _buildSettingsSection(
              title: 'Data Management',
              children: [
                _buildListTile(
                  icon: Iconsax.document_download,
                  title: 'Download My Data',
                  subtitle: 'Get a copy of your personal data',
                  onTap: () => _showDownloadDataDialog(),
                ),
                _buildListTile(
                  icon: Iconsax.trash,
                  title: 'Delete Account',
                  subtitle: 'Permanently delete your account and data',
                  onTap: () => _showDeleteAccountDialog(),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Privacy Information
            _buildSettingsSection(
              title: 'Privacy Information',
              children: [
                _buildListTile(
                  icon: Iconsax.document_text,
                  title: 'Privacy Policy',
                  subtitle: 'How we collect and use your data',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Privacy Policy coming soon!'),
                        backgroundColor: AppTheme.primaryColor,
                      ),
                    );
                  },
                ),
                _buildListTile(
                  icon: Iconsax.document_text,
                  title: 'Terms of Service',
                  subtitle: 'Our terms and conditions',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Terms of Service coming soon!'),
                        backgroundColor: AppTheme.primaryColor,
                      ),
                    );
                  },
                ),
                _buildListTile(
                  icon: Iconsax.message_question,
                  title: 'Contact Privacy Team',
                  subtitle: 'Questions about your privacy?',
                  onTap: () => context.go('/support'),
                ),
              ],
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryColor),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppTheme.primaryColor,
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryColor),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Iconsax.arrow_right_3, color: Colors.grey),
      onTap: onTap,
    );
  }

  void _showChangePasswordDialog() {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Current Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm New Password',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (newPasswordController.text == confirmPasswordController.text) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Password changed successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Passwords do not match!'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Change'),
          ),
        ],
      ),
    );
  }

  void _showLoginActivity() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Recent Login Activity'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLoginActivityItem('Chrome Browser', 'Today, 2:30 PM', 'Current session'),
            _buildLoginActivityItem('Mobile App', 'Yesterday, 9:15 AM', 'Successful'),
            _buildLoginActivityItem('Chrome Browser', '3 days ago, 4:22 PM', 'Successful'),
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

  Widget _buildLoginActivityItem(String device, String time, String status) {
    return ListTile(
      leading: const Icon(Iconsax.monitor, color: AppTheme.primaryColor),
      title: Text(device),
      subtitle: Text(time),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: status == 'Current session' ? Colors.green : Colors.grey,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          status,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  void _showDownloadDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Download My Data'),
        content: const Text('We will prepare a copy of your personal data and send it to your email address within 24 hours.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Data download request submitted! Check your email within 24 hours.'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Request'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text('This action cannot be undone. All your data, including pets, appointments, and purchase history will be permanently deleted.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Show confirmation dialog
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Are you absolutely sure?'),
                  content: const Text('Type "DELETE" to confirm account deletion.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Account deletion request submitted. You will receive an email confirmation.'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Delete Account'),
                    ),
                  ],
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
