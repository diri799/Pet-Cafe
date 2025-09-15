import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pawfect_care/features/products/models/product_model.dart';

class ProductNotifier extends StateNotifier<List<Product>> {
  ProductNotifier() : super([]);

  void setProducts(List<Product> products) {
    state = products;
  }

  void addProduct(Product product) {
    state = [...state, product];
  }

  void updateProduct(Product product) {
    final index = state.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      state = [
        ...state.sublist(0, index),
        product,
        ...state.sublist(index + 1),
      ];
    }
  }

  void removeProduct(String productId) {
    state = state.where((p) => p.id != productId).toList();
  }

  List<Product> getProductsByCategory(ProductCategory category) {
    return state.where((p) => p.category == category).toList();
  }

  List<Product> searchProducts(String query) {
    if (query.isEmpty) return state;

    return state.where((product) {
      return product.name.toLowerCase().contains(query.toLowerCase()) ||
             product.description.toLowerCase().contains(query.toLowerCase()) ||
             (product.brand?.toLowerCase().contains(query.toLowerCase()) ?? false);
    }).toList();
  }

  List<Product> getRelatedProducts(Product product) {
    return state.where((p) => p.category == product.category && p.id != product.id).take(5).toList();
  }
}

final productNotifierProvider = StateNotifierProvider<ProductNotifier, List<Product>>(
  (ref) => ProductNotifier(),
);

final featuredProductsProvider = Provider<List<Product>>((ref) {
  final products = ref.watch(productNotifierProvider);
  return products.where((p) => (p.rating ?? 0) >= 4.5).take(10).toList();
});

