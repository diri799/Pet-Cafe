import 'package:flutter/material.dart';

class SocialLoginButton extends StatelessWidget {
  final String iconPath;
  final VoidCallback onPressed;
  final double size;
  final double iconSize;
  final Color? backgroundColor;

  const SocialLoginButton({
    super.key,
    required this.iconPath,
    required this.onPressed,
    this.size = 56.0,
    this.iconSize = 24.0,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor ?? Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(16.0),
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16.0),
        splashColor: Theme.of(context).splashColor,
        highlightColor: Theme.of(context).highlightColor,
        child: Container(
          width: size,
          height: size,
          padding: const EdgeInsets.all(12.0),
          child: Center(
            child: _buildIcon(context),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(BuildContext context) {
    try {
      // Try to load the image as an asset
      return Image.asset(
        iconPath,
        width: iconSize,
        height: iconSize,
        errorBuilder: (context, error, stackTrace) {
          // Fallback to a placeholder if the image fails to load
          return _buildPlaceholderIcon();
        },
      );
    } catch (e) {
      // If there's an error (e.g., invalid path), show a placeholder
      return _buildPlaceholderIcon();
    }
  }

  Widget _buildPlaceholderIcon() {
    return Container(
      width: iconSize,
      height: iconSize,
      decoration: BoxDecoration(
        color: Colors.grey[300], // Light gray background for the placeholder
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.pets, // Using a paw icon as a fallback
        size: iconSize * 0.6,
        color: Colors.grey[600],
      ),
    );
  }
}

