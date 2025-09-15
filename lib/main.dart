import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pawfect_care/app_router.dart';
import 'package:pawfect_care/core/theme/app_theme.dart';
import 'package:pawfect_care/core/database/database_helper.dart';
import 'package:pawfect_care/core/services/notification_service.dart';
import 'package:pawfect_care/core/services/user_service.dart';
// Firebase services removed for web compatibility

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize database (skip on web)
  if (!kIsWeb) {
    try {
      await DatabaseHelper.instance.database;
    } catch (e) {
      debugPrint('Database initialization failed: $e');
    }
  }

  // Firebase initialization removed for web compatibility

  // Initialize user service
  try {
    await UserService().initialize();
  } catch (e) {
    debugPrint('User service initialization failed: $e');
  }

  // Initialize notification service (skip on web)
  if (!kIsWeb) {
    try {
      await NotificationService.initialize();
    } catch (e) {
      debugPrint('Notification service initialization failed: $e');
    }
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: DevicePreview(
        enabled: true,
        defaultDevice: Devices.ios.iPhone13,
        builder: (context) => MaterialApp.router(
          useInheritedMediaQuery: true,
          locale: DevicePreview.locale(context),
          builder: DevicePreview.appBuilder,
          title: 'PawfectCare',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          routerConfig: AppRouter.router,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English
          ],
        ),
      ),
    );
  }
}
