import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pawfect_care/features/products/models/product_model.dart';
import 'package:pawfect_care/features/cart/models/cart_item_model.dart';
import 'package:pawfect_care/core/services/user_service.dart';

class CartNotifier extends StateNotifier<List<CartItem>> {
  final UserService _userService = UserService();
  
  CartNotifier() : super([]) {
    // Load cart items asynchronously without blocking
    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    try {
      final cartData = await _userService.getCartItems();
      final cartItems = <CartItem>[];
      
      for (final item in cartData) {
        // In a real app, you'd fetch the product details from the product service
        // For now, we'll create a basic product object
        final product = Product(
          id: item['product_id'],
          name: 'Product ${item['product_id']}',
          description: 'Product description',
          price: 0.0, // You'd get this from the product service
          rating: 0.0,
          imageUrls: [],
          category: ProductCategory.other,
          stock: 0,
          brand: '',
          weight: 0.0,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        
        cartItems.add(CartItem(
          id: item['id'].toString(),
          product: product,
          quantity: item['quantity'],
          addedAt: DateTime.parse(item['created_at']),
        ));
      }
      
      // Only update state if we're still mounted
      if (mounted) {
        state = cartItems;
      }
    } catch (e) {
      // Handle error - cart will remain empty
      print('Failed to load cart items: $e');
      if (mounted) {
        state = [];
      }
    }
  }

  void addToCart(Product product, {int quantity = 1}) {
    // Update local state first
    final existingItemIndex = state.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingItemIndex != -1) {
      // Update existing item
      final existingItem = state[existingItemIndex];
      final updatedItem = existingItem.copyWith(
        quantity: existingItem.quantity + quantity,
      );
      state = [
        ...state.sublist(0, existingItemIndex),
        updatedItem,
        ...state.sublist(existingItemIndex + 1),
      ];
    } else {
      // Add new item
      final newItem = CartItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        product: product,
        quantity: quantity,
        addedAt: DateTime.now(),
      );
      state = [...state, newItem];
    }
    
    // Add to persistent storage (async, but don't wait)
    _userService.addToCart(product.id, quantity).catchError((e) {
      print('Failed to save to persistent storage: $e');
    });
  }

  void removeFromCart(String productId) {
    // Update local state first
    state = state.where((item) => item.product.id != productId).toList();
    
    // Remove from persistent storage (async, but don't wait)
    _userService.removeFromCart(productId).catchError((e) {
      print('Failed to remove from persistent storage: $e');
    });
  }

  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(productId);
      return;
    }

    final itemIndex = state.indexWhere((item) => item.product.id == productId);
    if (itemIndex != -1) {
      final updatedItem = state[itemIndex].copyWith(quantity: quantity);
      state = [
        ...state.sublist(0, itemIndex),
        updatedItem,
        ...state.sublist(itemIndex + 1),
      ];
    }
  }

  void clearCart() {
    state = [];
  }

  double get totalPrice {
    return state.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  int get totalItems {
    return state.fold(0, (sum, item) => sum + item.quantity);
  }

  bool isInCart(String productId) {
    return state.any((item) => item.product.id == productId);
  }
}

final cartNotifierProvider = StateNotifierProvider<CartNotifier, List<CartItem>>(
  (ref) => CartNotifier(),
);
