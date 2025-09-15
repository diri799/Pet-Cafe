import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pawfect_care/core/theme/app_theme.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Support'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_2),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              context.go('/home');
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
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
                border: Border.all(
                  color: AppTheme.primaryColor.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Iconsax.message_question,
                    size: 48,
                    color: AppTheme.primaryColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'How can we help you?',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'We\'re here to assist you with any questions or concerns about your pet care needs.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Contact Methods
            Text(
              'Contact Methods',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),

            _buildContactCard(
              icon: Iconsax.message,
              title: 'Live Chat',
              subtitle: 'Get instant help from our support team',
              onTap: () => _startLiveChat(context),
            ),

            _buildContactCard(
              icon: Iconsax.call,
              title: 'Phone Support',
              subtitle: 'Call us at +1 (555) 123-PETS',
              onTap: () => _makePhoneCall(context),
            ),

            _buildContactCard(
              icon: Iconsax.sms,
              title: 'Email Support',
              subtitle: 'Send us an email at support@pawfectcare.com',
              onTap: () => _sendEmail(context),
            ),

            const SizedBox(height: 24),

            // FAQ Section
            Text(
              'Frequently Asked Questions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),

            _buildFAQItem(
              question: 'How do I book an appointment?',
              answer: 'Navigate to the Appointments section and select "Book Appointment" to schedule with a veterinarian.',
            ),

            _buildFAQItem(
              question: 'Can I shop for pet supplies?',
              answer: 'Yes! Visit the Shop section to browse food, toys, accessories, and more for your pets.',
            ),

            _buildFAQItem(
              question: 'How do I adopt a pet?',
              answer: 'Check out the Pets section to see available pets from local shelters and rescue organizations.',
            ),

            _buildFAQItem(
              question: 'Is the app free to use?',
              answer: 'Yes, PawfectCare is free to download and use. Some premium features may be available with a subscription.',
            ),

            const SizedBox(height: 24),

            // Emergency Contact
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.red.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Iconsax.warning_2,
                    color: Colors.red,
                    size: 32,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Emergency Contact',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'For pet emergencies, contact your local emergency veterinary clinic immediately.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.red[700],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () => _callEmergency(context),
                    icon: const Icon(Iconsax.call, size: 16),
                    label: const Text('Call Emergency Vet'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
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

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 2,
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppTheme.primaryColor,
              size: 24,
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          trailing: const Icon(Iconsax.arrow_right_3),
          onTap: onTap,
        ),
      ),
    );
  }

  Widget _buildFAQItem({
    required String question,
    required String answer,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 1,
        child: ExpansionTile(
          title: Text(
            question,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                answer,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startLiveChat(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Iconsax.message, color: Colors.blue),
            SizedBox(width: 8),
            Text('Live Chat Support'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Connect with our support team instantly!'),
            SizedBox(height: 16),
            Text('Available 24/7 for:'),
            Text('• General pet care questions'),
            Text('• App usage help'),
            Text('• Account support'),
            Text('• Product inquiries'),
            SizedBox(height: 16),
            Text('Average response time: 2 minutes'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _simulateLiveChat(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Start Chat'),
          ),
        ],
      ),
    );
  }

  void _makePhoneCall(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Iconsax.call, color: Colors.green),
            SizedBox(width: 8),
            Text('Phone Support'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Call our support team directly:'),
            SizedBox(height: 16),
            Text('📞 +1 (555) 123-PETS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(height: 16),
            Text('Business Hours:'),
            Text('Monday - Friday: 8 AM - 8 PM'),
            Text('Saturday: 9 AM - 6 PM'),
            Text('Sunday: 10 AM - 4 PM'),
            SizedBox(height: 16),
            Text('Available for:'),
            Text('• Emergency pet advice'),
            Text('• Account assistance'),
            Text('• Product support'),
            Text('• Technical issues'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Opening phone dialer...'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            icon: const Icon(Iconsax.call, size: 16),
            label: const Text('Call Now'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _sendEmail(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Iconsax.sms, color: Colors.orange),
            SizedBox(width: 8),
            Text('Email Support'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Send us an email for detailed support:'),
            SizedBox(height: 16),
            Text('📧 support@pawfectcare.com', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 16),
            Text('Response time: Within 24 hours'),
            SizedBox(height: 16),
            Text('Best for:'),
            Text('• Detailed technical issues'),
            Text('• Account problems'),
            Text('• Feature requests'),
            Text('• Bug reports'),
            Text('• General feedback'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Opening email client...'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            icon: const Icon(Iconsax.sms, size: 16),
            label: const Text('Send Email'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _callEmergency(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Iconsax.warning_2, color: Colors.red),
            SizedBox(width: 8),
            Text('Emergency Contact'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('For pet emergencies, contact:'),
            SizedBox(height: 16),
            Text('🏥 Local Emergency Vet', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text('📞 (555) 911-PETS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(height: 16),
            Text('Available 24/7 for:'),
            Text('• Accidents and injuries'),
            Text('• Poisoning'),
            Text('• Breathing problems'),
            Text('• Severe illness'),
            Text('• Any life-threatening situation'),
            SizedBox(height: 16),
            Text('⚠️ If your pet is in immediate danger, call now!', 
                 style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Calling emergency veterinary clinic...'),
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 3),
                ),
              );
            },
            icon: const Icon(Iconsax.call, size: 16),
            label: const Text('Call Emergency'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _simulateLiveChat(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            CircleAvatar(
              radius: 12,
              backgroundColor: Colors.green,
              child: Icon(Icons.circle, color: Colors.white, size: 8),
            ),
            SizedBox(width: 8),
            Text('Live Chat'),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: Column(
            children: [
              // Chat messages
              Expanded(
                child: ListView(
                  children: [
                    _buildChatMessage(
                      'Support Agent',
                      'Hello! How can I help you today?',
                      isUser: false,
                    ),
                    _buildChatMessage(
                      'You',
                      'Hi, I need help with booking an appointment for my dog.',
                      isUser: true,
                    ),
                    _buildChatMessage(
                      'Support Agent',
                      'I\'d be happy to help! To book an appointment, go to the Appointments section and tap "Book Appointment". What type of appointment do you need?',
                      isUser: false,
                    ),
                  ],
                ),
              ),
              // Message input
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FloatingActionButton.small(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Message sent!'),
                          backgroundColor: Colors.blue,
                        ),
                      );
                    },
                    backgroundColor: Colors.blue,
                    child: const Icon(Iconsax.send_2, color: Colors.white, size: 16),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('End Chat'),
          ),
        ],
      ),
    );
  }

  Widget _buildChatMessage(String sender, String message, {required bool isUser}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: 12,
              backgroundColor: Colors.blue,
              child: Text(
                sender[0],
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isUser ? Colors.blue : Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sender,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isUser ? Colors.white70 : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    message,
                    style: TextStyle(
                      color: isUser ? Colors.white : Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 12,
              backgroundColor: Colors.green,
              child: Text(
                sender[0],
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
