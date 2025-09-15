import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pawfect_care/core/theme/app_theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? additionalActions;
  final bool showCart;
  final bool showAppointments;
  final bool showNotifications;
  final bool showProfile;
  final Widget? cartWidget;

  const CustomAppBar({
    super.key,
    required this.title,
    this.additionalActions,
    this.showCart = true,
    this.showAppointments = true,
    this.showNotifications = true,
    this.showProfile = true,
    this.cartWidget,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      backgroundColor: AppTheme.primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      leading: showCart
          ? (cartWidget ??
                IconButton(
                  icon: const Icon(Iconsax.shopping_cart),
                  onPressed: () => context.go('/cart'),
                  tooltip: 'Shopping Cart',
                ))
          : null,
      actions: [
        // Appointments icon
        if (showAppointments)
          IconButton(
            icon: const Icon(Iconsax.calendar),
            onPressed: () => context.go('/appointments'),
            tooltip: 'Appointments',
          ),

        // Notifications icon
        if (showNotifications)
          IconButton(
            icon: const Icon(Iconsax.notification),
            onPressed: () => context.go('/notification-settings'),
            tooltip: 'Notifications',
          ),

        // Profile icon
        if (showProfile)
          IconButton(
            icon: const Icon(Iconsax.user),
            onPressed: () => context.go('/profile'),
            tooltip: 'Profile',
          ),

        // Additional custom actions
        if (additionalActions != null) ...additionalActions!,
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
