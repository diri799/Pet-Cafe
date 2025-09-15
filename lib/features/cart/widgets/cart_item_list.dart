import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pawfect_care/core/theme/app_theme.dart';
import 'package:pawfect_care/features/cart/providers/cart_provider.dart';

class CartItemList extends ConsumerWidget {
  const CartItemList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(cartNotifierProvider);

    if (items.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Your cart is empty'),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Dismissible(
          key: Key(item.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            color: Colors.red,
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (_) => _removeItem(ref, item.product.id),
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item.product.imageUrls.isNotEmpty
                      ? item.product.imageUrls.first
                      : 'https://via.placeholder.com/80',
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
                ),
              ),
              title: Text(item.product.name),
              subtitle: Text(
                '\$${item.product.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Iconsax.minus),
                    onPressed: () => _updateQuantity(
                      ref,
                      item.product.id,
                      item.quantity - 1,
                    ),
                  ),
                  Text('${item.quantity}'),
                  IconButton(
                    icon: const Icon(Iconsax.add),
                    onPressed: () => _updateQuantity(
                      ref,
                      item.product.id,
                      item.quantity + 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _updateQuantity(WidgetRef ref, String productId, int quantity) {
    ref.read(cartNotifierProvider.notifier).updateQuantity(productId, quantity);
  }

  void _removeItem(WidgetRef ref, String productId) {
    ref.read(cartNotifierProvider.notifier).removeFromCart(productId);
  }
}

