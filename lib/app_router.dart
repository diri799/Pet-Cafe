import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pawfect_care/core/theme/app_theme.dart';
import 'package:pawfect_care/core/services/auth_service.dart';
import 'package:pawfect_care/features/auth/screens/login_screen.dart';
// Role selection screen (accessible via profile "Change Role")
import 'package:pawfect_care/features/auth/screens/role_selection_screen.dart';
import 'package:pawfect_care/features/auth/screens/signup_screen.dart';
import 'package:pawfect_care/core/models/user_model.dart';
import 'package:pawfect_care/features/cart/screens/cart_screen.dart';
import 'package:pawfect_care/features/home/screens/home_screen.dart';
import 'package:pawfect_care/features/pet/screens/pet_detail_screen.dart';
import 'package:pawfect_care/features/product/screens/product_detail_screen.dart';
import 'package:pawfect_care/features/splash/screens/splash_screen.dart';
import 'package:pawfect_care/features/pet_owner/screens/pet_owner_dashboard.dart';
import 'package:pawfect_care/features/veterinarian/screens/vet_dashboard.dart';
import 'package:pawfect_care/features/shelter/screens/shelter_dashboard.dart';
import 'package:pawfect_care/features/blog/screens/blog_list_screen.dart';
import 'package:pawfect_care/features/blog/screens/animal_tiktok_screen.dart';
import 'package:pawfect_care/features/notifications/screens/notifications_screen.dart';
import 'package:pawfect_care/features/shop/screens/shop_screen.dart';
import 'package:pawfect_care/features/profile/screens/profile_screen.dart';
import 'package:pawfect_care/features/profile/screens/edit_profile_screen.dart';
import 'package:pawfect_care/features/profile/screens/settings_screen.dart';
import 'package:pawfect_care/features/profile/screens/privacy_security_screen.dart';
import 'package:pawfect_care/features/shelter/screens/shelter_pets_screen.dart';
import 'package:pawfect_care/features/blog/screens/create_blog_screen.dart';
import 'package:pawfect_care/features/reviews/screens/write_review_screen.dart';
import 'package:pawfect_care/features/reviews/screens/reviews_list_screen.dart';
import 'package:pawfect_care/features/products/models/product_model.dart';
import 'package:pawfect_care/features/support/screens/support_screen.dart';
import 'package:pawfect_care/features/scan/screens/scan_screen.dart';
import 'package:pawfect_care/features/notifications/screens/notification_settings_screen.dart';
import 'package:pawfect_care/features/cart/screens/checkout_screen.dart';
import 'package:pawfect_care/features/cart/screens/order_confirmation_screen.dart';
import 'package:pawfect_care/features/pets/screens/pet_list_screen.dart';
import 'package:pawfect_care/features/pets/screens/add_pet_screen.dart';
import 'package:pawfect_care/features/appointments/screens/appointment_list_screen.dart';
import 'package:pawfect_care/features/appointments/screens/appointment_booking_screen.dart';
import 'package:pawfect_care/features/veterinarian/screens/vet_dashboard_screen.dart';
import 'package:pawfect_care/features/veterinarian/screens/medical_records_screen.dart';
import 'package:pawfect_care/features/shelter/screens/shelter_dashboard_screen.dart';
import 'package:pawfect_care/features/contact/screens/contact_us_screen.dart';
import 'package:pawfect_care/features/contact/screens/feedback_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(
        title: const Text('Page Not Found'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found: ${state.uri.path}',
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/login'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Go to Login'),
            ),
          ],
        ),
      ),
    ),
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      // Role selection screen (accessible via profile "Change Role")
      GoRoute(
        path: '/role-selection',
        builder: (context, state) => const RoleSelectionScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/signup-form',
        builder: (context, state) {
          final role = state.extra as UserRole?;
          return SignupScreen(selectedRole: role);
        },
      ),

      // Role-based dashboards
      GoRoute(
        path: '/pet-owner-dashboard',
        builder: (context, state) => const PetOwnerDashboard(),
      ),
      GoRoute(
        path: '/vet-dashboard',
        builder: (context, state) => const VetDashboard(),
      ),
      GoRoute(
        path: '/vet-blog',
        builder: (context, state) => const BlogListScreen(),
      ),
      GoRoute(
        path: '/vet-animal-feed',
        builder: (context, state) => const AnimalTikTokScreen(),
      ),
      GoRoute(
        path: '/shelter-dashboard',
        builder: (context, state) => const ShelterDashboard(),
      ),
      GoRoute(
        path: '/shelter-blog',
        builder: (context, state) => const BlogListScreen(),
      ),
      GoRoute(
        path: '/shelter-animal-feed',
        builder: (context, state) => const AnimalTikTokScreen(),
      ),

      // Shared features with navigation
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => ScaffoldWithNavBar(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/shop',
            builder: (context, state) => const ShopScreen(),
          ),
          GoRoute(
            path: '/blog',
            builder: (context, state) => const BlogListScreen(),
          ),
          GoRoute(
            path: '/appointments',
            builder: (context, state) => const AppointmentListScreen(),
          ),
          GoRoute(
            path: '/cart',
            builder: (context, state) => const CartScreen(),
          ),
          GoRoute(
            path: '/pets',
            builder: (context, state) => const ShelterPetsScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: '/animal-feed',
            builder: (context, state) => const AnimalTikTokScreen(),
          ),
        ],
      ),

      // Product routes
      GoRoute(
        path: '/product/:id',
        builder: (context, state) {
          final product = state.extra as Map<String, dynamic>?;
          if (product != null) {
            return ProductDetailScreen(product: product);
          }
          return const Scaffold(body: Center(child: Text('Product not found')));
        },
      ),

      // Pet routes
      GoRoute(
        path: '/pet/:id',
        builder: (context, state) {
          final pet = state.extra as Map<String, dynamic>?;
          if (pet != null) {
            return PetDetailScreen(pet: pet);
          }
          return const Scaffold(body: Center(child: Text('Pet not found')));
        },
      ),

      // Appointment routes
      GoRoute(
        path: '/book-appointment',
        builder: (context, state) => const AppointmentBookingScreen(),
      ),

      // Blog creation route
      GoRoute(
        path: '/create-blog',
        builder: (context, state) => const CreateBlogScreen(),
      ),

      // Review routes
      GoRoute(
        path: '/write-review',
        builder: (context, state) {
          final product = state.extra as Product?;
          if (product != null) {
            return WriteReviewScreen(product: product);
          }
          return const Scaffold(body: Center(child: Text('Product not found')));
        },
      ),
      GoRoute(
        path: '/reviews',
        builder: (context, state) {
          final product = state.extra as Product?;
          if (product != null) {
            return ReviewsListScreen(product: product);
          }
          return const Scaffold(body: Center(child: Text('Product not found')));
        },
      ),

      // Support route
      GoRoute(
        path: '/support',
        builder: (context, state) => const SupportScreen(),
      ),

      // Scan route
      GoRoute(path: '/scan', builder: (context, state) => const ScanScreen()),
      GoRoute(
        path: '/notification-settings',
        builder: (context, state) => const NotificationSettingsScreen(),
      ),

      // Profile management routes
      GoRoute(
        path: '/edit-profile',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/privacy-security',
        builder: (context, state) => const PrivacySecurityScreen(),
      ),

      // Checkout and Order routes
      GoRoute(
        path: '/checkout',
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>?;
          if (data != null &&
              data['cartItems'] != null &&
              data['totalAmount'] != null) {
            return CheckoutScreen(
              cartItems: data['cartItems'],
              totalAmount: data['totalAmount'],
            );
          }
          // If no cart data, redirect to cart screen
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go('/cart');
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),
      GoRoute(
        path: '/order-confirmation',
        builder: (context, state) {
          final orderData = state.extra as Map<String, dynamic>?;
          if (orderData != null) {
            return OrderConfirmationScreen(orderData: orderData);
          }
          // If no order data, redirect to home
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go('/home');
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),

      // Pet Management routes
      GoRoute(
        path: '/pets',
        builder: (context, state) => const PetListScreen(),
      ),
      GoRoute(
        path: '/pets/add',
        builder: (context, state) => const AddPetScreen(),
      ),

      // Appointment routes
      GoRoute(
        path: '/appointments',
        builder: (context, state) => const AppointmentListScreen(),
      ),
      GoRoute(
        path: '/appointments/book',
        builder: (context, state) => const AppointmentBookingScreen(),
      ),

      // Veterinarian routes
      GoRoute(
        path: '/vet-dashboard',
        builder: (context, state) => const VetDashboardScreen(),
      ),
      GoRoute(
        path: '/vet/medical-records',
        builder: (context, state) => const MedicalRecordsScreen(),
      ),

      // Shelter routes
      GoRoute(
        path: '/shelter-dashboard',
        builder: (context, state) => const ShelterDashboardScreen(),
      ),

      GoRoute(
        path: '/blog/create',
        builder: (context, state) => const CreateBlogScreen(),
      ),

      // Contact routes
      GoRoute(
        path: '/contact',
        builder: (context, state) => const ContactUsScreen(),
      ),
      GoRoute(
        path: '/feedback',
        builder: (context, state) => const FeedbackScreen(),
      ),

      // Notification routes
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/notifications/settings',
        builder: (context, state) => const NotificationSettingsScreen(),
      ),
    ],

    redirect: (context, state) async {
      final authService = AuthService();
      final isLoggedIn = await authService.checkLoginStatus();

      // If not logged in and trying to access protected routes
      if (!isLoggedIn && !_isPublicRoute(state.uri.path)) {
        return '/login';
      }

      // If logged in and on splash/login, redirect to dashboard
      if (isLoggedIn && (state.uri.path == '/' || state.uri.path == '/login')) {
        return authService.getDashboardRoute();
      }

      return null;
    },
  );

  static bool _isPublicRoute(String path) {
    final publicRoutes = ['/login', '/signup', '/'];
    return publicRoutes.contains(path);
  }
}

class ScaffoldWithNavBar extends StatefulWidget {
  const ScaffoldWithNavBar({required this.child, super.key});

  final Widget child;

  @override
  State<ScaffoldWithNavBar> createState() => _ScaffoldWithNavBarState();
}

class _ScaffoldWithNavBarState extends State<ScaffoldWithNavBar> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Get current route to determine active index
    final location = GoRouterState.of(context).uri.path;
    _currentIndex = _getCurrentIndex(location);

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/home');
              break;
            case 1:
              context.go('/shop');
              break;
            case 2:
              context.go('/blog');
              break;
            case 3:
              context.go('/appointments');
              break;
            case 4:
              context.go('/cart');
              break;
            case 5:
              context.go('/pets');
              break;
            case 6:
              context.go('/profile');
              break;
            case 7:
              context.go('/animal-feed');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Iconsax.home_2), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Iconsax.shop), label: 'Shop'),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.document_text),
            label: 'Blog',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.calendar),
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(icon: Icon(Iconsax.pet), label: 'Pets'),
          BottomNavigationBarItem(icon: Icon(Iconsax.user), label: 'Profile'),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.video_play),
            label: 'Feed',
          ),
        ],
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  int _getCurrentIndex(String location) {
    switch (location) {
      case '/home':
        return 0;
      case '/shop':
        return 1;
      case '/blog':
        return 2;
      case '/appointments':
        return 3;
      case '/cart':
        return 4;
      case '/pets':
        return 5;
      case '/profile':
        return 6;
      case '/animal-feed':
        return 7;
      default:
        return 0;
    }
  }
}
