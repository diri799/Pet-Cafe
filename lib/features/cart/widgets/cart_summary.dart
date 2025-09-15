import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pawfect_care/core/theme/app_theme.dart';
import 'package:pawfect_care/features/cart/providers/cart_provider.dart';
import 'package:pawfect_care/features/cart/utils/cart_utils.dart';

class CartSummary extends ConsumerWidget {
  const CartSummary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(cartNotifierProvider);

    if (items.isEmpty) return const SizedBox.shrink();

    final subtotal = CartUtils.calculateSubtotal(items);
    final shipping = CartUtils.calculateShipping(items);
    final total = subtotal + shipping;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSummaryRow('Subtotal', _formatPrice(subtotal)),
          const SizedBox(height: 8),
          _buildSummaryRow('Shipping', _formatPrice(shipping)),
          const Divider(height: 32),
          _buildSummaryRow(
            'Total',
            _formatPrice(total),
            isTotal: true,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _checkout(context, ref),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Proceed to Checkout',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Colors.black : Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? AppTheme.primaryColor : null,
          ),
        ),
      ],
    );
  }

  String _formatPrice(double price) {
    return '\$${price.toStringAsFixed(2)}';
  }

  Future<void> _checkout(BuildContext context, WidgetRef ref) async {
    // Show loading indicator
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    
    try {
      // TODO: Implement checkout process
      // 1. Validate cart items
      // 2. Process payment
      // 3. Create order
      // 4. Clear cart
      // 5. Navigate to order confirmation
      
      // For now, just show a success message
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Checkout successful!')),
      );
      
      // Clear cart
      ref.read(cartNotifierProvider.notifier).clearCart();
      
      // Navigate to home
      navigator.popUntil((route) => route.isFirst);
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Checkout failed: $e')),
      );
    }
  }
}

