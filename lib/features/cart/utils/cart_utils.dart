import 'package:pawfect_care/features/cart/models/cart_item_model.dart';

class CartUtils {
  // Calculate subtotal for a list of cart items
  static double calculateSubtotal(List<CartItem> items) {
    return items.fold(0, (sum, item) => sum + item.totalPrice);
  }

  // Calculate shipping cost
  static double calculateShipping(List<CartItem> items, {double flatRate = 4.99}) {
    return items.isEmpty ? 0 : flatRate;
  }

  // Calculate total cost (subtotal + shipping)
  static double calculateTotal(List<CartItem> items, {double flatRate = 4.99}) {
    return calculateSubtotal(items) + calculateShipping(items, flatRate: flatRate);
  }

  // Check if a product is in the cart
  static bool isProductInCart(List<CartItem> items, String productId) {
    return items.any((item) => item.product.id == productId);
  }

  // Get quantity of a product in the cart
  static int getProductQuantity(List<CartItem> items, String productId) {
    final item = items.firstWhere(
      (item) => item.product.id == productId,
      orElse: () => CartItem.empty(),
    );
    return item.quantity;
  }

  // Validate cart items (check stock, etc.)
  static List<CartItem> validateCartItems(List<CartItem> items) {
    return items.where((item) {
      // Remove items with invalid products
      if (item.product.id.isEmpty) return false;

      // Update quantity if it exceeds available stock
      if (item.quantity > item.product.stock) {
        // item = item.updateQuantity(item.product.stock); // This line is ineffective as item is final
        return false; // Exclude items exceeding stock
      }

      return item.quantity > 0;
    }).toList();
  }
}

