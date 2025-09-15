import 'package:flutter/material.dart';
import 'package:pawfect_care/core/theme/app_theme.dart';

class PageIndicator extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final double dotSize;
  final double activeDotSize;
  final double spacing;

  const PageIndicator({
    super.key,
    required this.currentPage,
    required this.totalPages,
    this.dotSize = 8.0,
    this.activeDotSize = 12.0,
    this.spacing = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(totalPages, (index) {
        final isActive = index == currentPage;
        final size = isActive ? activeDotSize : dotSize;
        final color = isActive ? AppTheme.primaryColor : AppTheme.primaryColor.withValues(alpha: 0.3);
        
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: spacing / 2),
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.5),
                      blurRadius: 4,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
        );
      }),
    );
  }
}

