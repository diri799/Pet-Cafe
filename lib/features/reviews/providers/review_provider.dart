import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pawfect_care/features/reviews/models/review_model.dart';
import 'package:pawfect_care/core/database/database_helper.dart';

class ReviewNotifier extends StateNotifier<List<Review>> {
  ReviewNotifier() : super([]);

  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<void> loadReviews(String productId) async {
    try {
      final reviewMaps = await _dbHelper.getReviewsForProduct(productId);
      final reviews = reviewMaps.map((map) => Review.fromMap(map)).toList();
      state = reviews;
    } catch (e) {
      // Handle error
      state = [];
    }
  }

  Future<void> addReview(Review review) async {
    try {
      await _dbHelper.insertReview(review.toMap());
      state = [review, ...state];
    } catch (e) {
      // Handle error
    }
  }

  Future<void> updateReview(Review review) async {
    try {
      await _dbHelper.updateReview(review.toMap());
      state = state.map((r) => r.id == review.id ? review : r).toList();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> deleteReview(String reviewId) async {
    try {
      await _dbHelper.deleteReview(reviewId);
      state = state.where((r) => r.id != reviewId).toList();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> markHelpful(String reviewId) async {
    try {
      final review = state.firstWhere((r) => r.id == reviewId);
      final updatedReview = review.copyWith(
        helpfulCount: review.helpfulCount + 1,
        updatedAt: DateTime.now(),
      );
      await _dbHelper.updateReview(updatedReview.toMap());
      state = state.map((r) => r.id == reviewId ? updatedReview : r).toList();
    } catch (e) {
      // Handle error
    }
  }

  double getAverageRating() {
    if (state.isEmpty) return 0.0;
    final totalRating = state.fold(0.0, (sum, review) => sum + review.rating);
    return totalRating / state.length;
  }

  Map<int, int> getRatingDistribution() {
    final distribution = <int, int>{};
    for (int i = 1; i <= 5; i++) {
      distribution[i] = state.where((r) => r.rating.round() == i).length;
    }
    return distribution;
  }
}

final reviewProvider = StateNotifierProvider<ReviewNotifier, List<Review>>((ref) {
  return ReviewNotifier();
});

final averageRatingProvider = Provider<double>((ref) {
  final reviews = ref.watch(reviewProvider);
  if (reviews.isEmpty) return 0.0;
  final totalRating = reviews.fold(0.0, (sum, review) => sum + review.rating);
  return totalRating / reviews.length;
});

final ratingDistributionProvider = Provider<Map<int, int>>((ref) {
  final reviews = ref.watch(reviewProvider);
  final distribution = <int, int>{};
  for (int i = 1; i <= 5; i++) {
    distribution[i] = reviews.where((r) => r.rating.round() == i).length;
  }
  return distribution;
});