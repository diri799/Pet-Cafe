import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  // Initialize notification service
  static Future<void> initialize() async {
    if (kIsWeb) {
      // Skip Firebase initialization on web platform
      debugPrint('NotificationService: Skipping Firebase initialization on web platform');
      return;
    }
    
    final instance = NotificationService();
    await instance._setupMessaging();
  }

  // Setup messaging (simplified for web compatibility)
  Future<void> _setupMessaging() async {
    try {
      debugPrint('NotificationService: Setting up local notifications');
      // For web platform, we'll use local storage for notifications
      // In a real app, you would integrate with browser notifications API
    } catch (e) {
      debugPrint('Error setting up messaging: $e');
    }
  }

  // Send push notification to user (simplified for web)
  Future<void> sendPushNotification({
    required String userId,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      debugPrint('Would send push notification: $title - $body');
      
      // Save notification to local storage
      await _saveNotificationToLocalStorage(
        userId: userId,
        title: title,
        body: body,
        data: data,
        type: 'push',
      );
    } catch (e) {
      debugPrint('Error sending push notification: $e');
    }
  }

  // Send email notification (simplified for web)
  Future<void> sendEmailNotification({
    required String email,
    required String subject,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      debugPrint('Would send email notification to: $email');
      debugPrint('Subject: $subject');
      debugPrint('Body: $body');
      
      // Save email notification to local storage
      await _saveEmailNotificationToLocalStorage(
        email: email,
        subject: subject,
        body: body,
        data: data,
      );
    } catch (e) {
      debugPrint('Error sending email notification: $e');
    }
  }

  // Notify user about new pet (simplified)
  Future<void> notifyNewPet({
    required String userId,
    required String petName,
    required String petType,
    required String shelterName,
  }) async {
    try {
      debugPrint('New pet notification: $petName ($petType) at $shelterName');
      
      // Send push notification
      await sendPushNotification(
        userId: userId,
        title: 'New Pet Available! 🐾',
        body: '$petName ($petType) is now available at $shelterName',
        data: {
          'type': 'new_pet',
          'petName': petName,
          'petType': petType,
          'shelterName': shelterName,
        },
      );
    } catch (e) {
      debugPrint('Error notifying about new pet: $e');
    }
  }

  // Notify user about appointment (simplified)
  Future<void> notifyAppointment({
    required String userId,
    required String petName,
    required String appointmentType,
    required DateTime appointmentDate,
    required String veterinarianName,
  }) async {
    try {
      debugPrint('Appointment notification: $appointmentType for $petName');
      
      await sendPushNotification(
        userId: userId,
        title: 'Appointment Reminder 📅',
        body: '$appointmentType for $petName with Dr. $veterinarianName',
        data: {
          'type': 'appointment',
          'petName': petName,
          'appointmentType': appointmentType,
          'appointmentDate': appointmentDate.toIso8601String(),
          'veterinarianName': veterinarianName,
        },
      );
    } catch (e) {
      debugPrint('Error notifying about appointment: $e');
    }
  }

  // Notify user about blog update (simplified)
  Future<void> notifyBlogUpdate({
    required String userId,
    required String blogTitle,
    required String blogCategory,
  }) async {
    try {
      debugPrint('Blog update notification: $blogTitle - $blogCategory');
      
      await sendPushNotification(
        userId: userId,
        title: 'New Blog Post 📝',
        body: '$blogTitle - $blogCategory',
        data: {
          'type': 'blog_update',
          'blogTitle': blogTitle,
          'blogCategory': blogCategory,
        },
      );
    } catch (e) {
      debugPrint('Error notifying about blog update: $e');
    }
  }

  // Save notification to local storage
  Future<void> _saveNotificationToLocalStorage({
    required String userId,
    required String title,
    required String body,
    Map<String, dynamic>? data,
    required String type,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notificationsKey = 'notifications_$userId';
      final existingNotifications = prefs.getStringList(notificationsKey) ?? [];
      
      final notification = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'userId': userId,
        'title': title,
        'body': body,
        'data': data,
        'type': type,
        'read': false,
        'createdAt': DateTime.now().toIso8601String(),
      };
      
      existingNotifications.insert(0, notification.toString());
      
      // Keep only the last 50 notifications
      if (existingNotifications.length > 50) {
        existingNotifications.removeRange(50, existingNotifications.length);
      }
      
      await prefs.setStringList(notificationsKey, existingNotifications);
    } catch (e) {
      debugPrint('Error saving notification to local storage: $e');
    }
  }

  // Save email notification to local storage
  Future<void> _saveEmailNotificationToLocalStorage({
    required String email,
    required String subject,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final emailNotificationsKey = 'email_notifications';
      final existingEmails = prefs.getStringList(emailNotificationsKey) ?? [];
      
      final emailNotification = {
        'email': email,
        'subject': subject,
        'body': body,
        'data': data,
        'status': 'pending',
        'createdAt': DateTime.now().toIso8601String(),
      };
      
      existingEmails.insert(0, emailNotification.toString());
      
      // Keep only the last 20 email notifications
      if (existingEmails.length > 20) {
        existingEmails.removeRange(20, existingEmails.length);
      }
      
      await prefs.setStringList(emailNotificationsKey, existingEmails);
    } catch (e) {
      debugPrint('Error saving email notification to local storage: $e');
    }
  }

  // Get user notifications from local storage
  Future<List<Map<String, dynamic>>> getUserNotifications(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notificationsKey = 'notifications_$userId';
      final notifications = prefs.getStringList(notificationsKey) ?? [];
      
      return notifications.map((notificationString) {
        // This is a simplified version - in a real app you'd parse JSON
        return {
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'title': 'Sample Notification',
          'body': 'This is a sample notification',
          'read': false,
          'createdAt': DateTime.now().toIso8601String(),
        };
      }).toList();
    } catch (e) {
      debugPrint('Error getting user notifications: $e');
      return [];
    }
  }

  // Mark notification as read
  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      debugPrint('Marking notification as read: $notificationId');
      // In a real app, you would update the local storage
    } catch (e) {
      debugPrint('Error marking notification as read: $e');
    }
  }

  // Update user notification settings
  Future<void> updateNotificationSettings({
    required String userId,
    bool? newPets,
    bool? appointments,
    bool? blogUpdates,
    bool? emailNotifications,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsKey = 'notification_settings_$userId';
      
      final settings = {
        'newPets': newPets ?? true,
        'appointments': appointments ?? true,
        'blogUpdates': blogUpdates ?? true,
        'emailNotifications': emailNotifications ?? true,
        'updatedAt': DateTime.now().toIso8601String(),
      };
      
      await prefs.setString(settingsKey, settings.toString());
      debugPrint('Updated notification settings for user: $userId');
    } catch (e) {
      debugPrint('Error updating notification settings: $e');
    }
  }
}