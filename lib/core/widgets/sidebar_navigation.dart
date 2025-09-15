import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pawfect_care/core/theme/app_theme.dart';

class SidebarNavigation extends StatefulWidget {
  final Widget child;
  final String currentRoute;

  const SidebarNavigation({
    super.key,
    required this.child,
    required this.currentRoute,
  });

  @override
  State<SidebarNavigation> createState() => _SidebarNavigationState();
}

class _SidebarNavigationState extends State<SidebarNavigation> {
  bool _isExpanded = true;

  final List<NavigationItem> _navigationItems = [
    NavigationItem(icon: Iconsax.home_2, label: 'Home', route: '/home'),
    NavigationItem(icon: Iconsax.shop, label: 'Shop', route: '/shop'),
    NavigationItem(icon: Iconsax.document_text, label: 'Blog', route: '/blog'),
    NavigationItem(icon: Iconsax.pet, label: 'Pets', route: '/pets'),
    NavigationItem(
      icon: Iconsax.video_play,
      label: 'Feed',
      route: '/animal-feed',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    if (isMobile) {
      // On mobile, use bottom navigation
      return Scaffold(
        body: widget.child,
        bottomNavigationBar: _buildBottomNavigation(),
      );
    }

    // On larger screens, use sidebar
    return Scaffold(
      body: Row(
        children: [
          _buildSidebar(),
          Expanded(child: widget.child),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: _isExpanded ? 250.0 : 70.0,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            height: 80,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                if (_isExpanded) ...[
                  const Icon(Iconsax.pet, color: Colors.white, size: 32),
                  const SizedBox(width: 12.0),
                  const Expanded(
                    child: Text(
                      'Pawfect Care',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ] else
                  const Icon(Iconsax.pet, color: Colors.white, size: 32),
                IconButton(
                  icon: Icon(
                    _isExpanded ? Iconsax.arrow_left_2 : Iconsax.arrow_right_2,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                ),
              ],
            ),
          ),
          // Navigation Items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: _navigationItems.length,
              itemBuilder: (context, index) {
                final item = _navigationItems[index];
                final isSelected = widget.currentRoute == item.route;

                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Material(
                    color: isSelected
                        ? AppTheme.primaryColor.withValues(alpha: 0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => context.go(item.route),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              item.icon,
                              color: isSelected
                                  ? AppTheme.primaryColor
                                  : Colors.grey[600],
                              size: 24,
                            ),
                            if (_isExpanded) ...[
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  item.label,
                                  style: TextStyle(
                                    color: isSelected
                                        ? AppTheme.primaryColor
                                        : Colors.grey[700],
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    final currentIndex = _getCurrentIndex(widget.currentRoute);

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        final item = _navigationItems[index];
        context.go(item.route);
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppTheme.primaryColor,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      items: _navigationItems
          .map(
            (item) => BottomNavigationBarItem(
              icon: Icon(item.icon),
              label: item.label,
            ),
          )
          .toList(),
    );
  }

  int _getCurrentIndex(String location) {
    for (int i = 0; i < _navigationItems.length; i++) {
      if (_navigationItems[i].route == location) {
        return i;
      }
    }
    return 0;
  }
}

class NavigationItem {
  final IconData icon;
  final String label;
  final String route;

  NavigationItem({
    required this.icon,
    required this.label,
    required this.route,
  });
}
