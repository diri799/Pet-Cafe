import 'package:pawfect_care/features/products/models/product_model.dart';

class ProductUtils {
  // Get product category display name
  static String getCategoryName(ProductCategory category) {
    return category.toString().split('.').last;
  }

  // Format price with currency
  static String formatPrice(double price) {
    return '\$${price.toStringAsFixed(2)}';
  }

  // Get product availability status
  static String getAvailabilityStatus(Product product) {
    if (product.stock <= 0) {
      return 'Out of Stock';
    } else if (product.stock < 10) {
      return 'Only ${product.stock} left in stock';
    } else {
      return 'In Stock';
    }
  }

  // Get product rating display
  static String getRatingDisplay(double? rating) {
    if (rating == null || rating == 0) return 'No ratings yet';
    return '${rating.toStringAsFixed(1)}/5.0';
  }

  // Get product discount percentage
  static int getDiscountPercentage(double originalPrice, double? salePrice) {
    if (salePrice == null || salePrice >= originalPrice) return 0;
    return ((originalPrice - salePrice) / originalPrice * 100).round();
  }
}

