import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pawfect_care/core/theme/app_theme.dart';
import 'package:pawfect_care/core/widgets/custom_app_bar.dart';
import 'package:pawfect_care/features/products/models/product_model.dart';
import 'package:pawfect_care/features/products/widgets/product_card.dart';
import 'package:pawfect_care/features/products/providers/product_provider.dart';
import 'package:pawfect_care/features/cart/providers/cart_provider.dart';

class ShopScreen extends ConsumerStatefulWidget {
  const ShopScreen({super.key});

  @override
  ConsumerState<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends ConsumerState<ShopScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';

  final List<String> _categories = [
    'All',
    'Food',
    'Toys',
    'Grooming',
    'Health',
    'Accessories',
    'Clothing',
  ];

  @override
  void initState() {
    super.initState();
    // Delay the provider modification to avoid the "modify provider during build" error
    Future.microtask(() => _loadProducts());
  }

  void _loadProducts() {
    final products = [
      // Food Products
      Product(
        id: 'food1',
        name: 'Premium Dog Food',
        description:
            'Nutritionally balanced dog food with real meat as the first ingredient.',
        price: 49.99,
        rating: 4.9,
        imageUrls: ['assets/images/pfood1-removebg-preview.png'],
        category: ProductCategory.food,
        stock: 10,
        brand: 'NutriPaws',
        weight: 25.0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: 'food3',
        name: 'Premium Dog Food',
        description: 'Nutritionally balanced dog food with real fish.',
        price: 40.99,
        rating: 4.5,
        imageUrls: ['assets/images/pfood3-removebg-preview.png'],
        category: ProductCategory.food,
        stock: 10,
        brand: 'Vita Pet',
        weight: 25.0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: 'food4',
        name: 'Premium Dog Food',
        description:
            'Nutritionally balanced dog food with real meat and rice as the first ingredient.',
        price: 50.99,
        rating: 4.7,
        imageUrls: ['assets/images/pfood1-removebg-preview.png'],
        category: ProductCategory.food,
        stock: 10,
        brand: 'Himalaya',
        weight: 26.0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: 'food5',
        name: 'Premium Cat Food',
        description:
            'Nutritionally balanced cat food with real ocean fish as the first ingredient.',
        price: 40.99,
        rating: 3.9,
        imageUrls: ['assets/images/pfood5-removebg-preview.png'],
        category: ProductCategory.food,
        stock: 16,
        brand: 'Meow Mix',
        weight: 15.0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: 'food8',
        name: 'Premium Cat Food',
        description:
            'Nutritionally balanced dog food with real meat as the first ingredient.',
        price: 49.99,
        rating: 4.9,
        imageUrls: ['assets/images/pfood8-removebg-preview.png'],
        category: ProductCategory.food,
        stock: 10,
        brand: 'Fluffy',
        weight: 25.0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: 'food6',
        name: 'Premium Dog Food',
        description:
            'Nutritionally balanced dog food with real meat as the first ingredient.',
        price: 42.99,
        rating: 4.0,
        imageUrls: ['assets/images/pfood7-removebg-preview.png'],
        category: ProductCategory.food,
        stock: 30,
        brand: 'Whiskas',
        weight: 45.0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: 'food7',
        name: 'Premium Bird Food',
        description: 'Nutritionally balanced dog food with rice crisps.',
        price: 56.99,
        rating: 2.9,
        imageUrls: ['assets/images/pfood9-removebg-preview.png'],
        category: ProductCategory.food,
        stock: 10,
        brand: 'NutriPaws',
        weight: 29.0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: 'food2',
        name: 'Cat Treats',
        description: 'Delicious treats for your feline friend.',
        price: 12.99,
        rating: 4.7,
        imageUrls: ['assets/images/pfood2-removebg-preview.png'],
        category: ProductCategory.food,
        stock: 25,
        brand: 'FelineFavorites',
        weight: 2.0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: 'food10',
        name: 'Premium  Bird Food',
        description: 'Nutritionally balanced Bird food.',
        price: 56.99,
        rating: 4.3,
        imageUrls: ['assets/images/pfood10-removebg-preview.png'],
        category: ProductCategory.food,
        stock: 10,
        brand: 'ZuProom',
        weight: 22.0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: 'food11',
        name: 'Premium  Bird Food',
        description: 'Nutritionally balanced Bird food.',
        price: 56.99,
        rating: 4.3,
        imageUrls: ['assets/images/pfood11-removebg-preview.png'],
        category: ProductCategory.food,
        stock: 10,
        brand: 'ZuProom',
        weight: 22.0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: 'food12',
        name: 'Premium  Bird Food',
        description: 'Nutritionally balanced Bird food.',
        price: 56.99,
        rating: 4.3,
        imageUrls: ['assets/images/pfood12-removebg-preview.png'],
        category: ProductCategory.food,
        stock: 10,
        brand: 'ZuProom',
        weight: 22.0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: 'food13',
        name: 'Premium  Rabbit Food',
        description: 'Nutritionally balanced Rabbit food.',
        price: 20.99,
        rating: 3.3,
        imageUrls: ['assets/images/pfood13-removebg-preview.png'],
        category: ProductCategory.food,
        stock: 10,
        brand: 'ZuProom',
        weight: 22.0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: 'food14',
        name: 'Premium  Rabbit Food',
        description: 'Nutritionally balanced Rabbit food.',
        price: 56.99,
        rating: 4.3,
        imageUrls: ['assets/images/pfood10-removebg-preview.png'],
        category: ProductCategory.food,
        stock: 10,
        brand: 'Supreme',
        weight: 22.0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: 'food15',
        name: 'Premium  Rabbit Food',
        description: 'Nutritionally balanced Rabbit food.',
        price: 56.99,
        rating: 4.3,
        imageUrls: ['assets/images/pfood15-removebg-preview.png'],
        category: ProductCategory.food,
        stock: 10,
        brand: 'Supreme',
        weight: 22.0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: 'food16',
        name: 'Premium  Lizard Food',
        description: 'Nutritionally balanced Lizard food.',
        price: 30.99,
        rating: 5.0,
        imageUrls: ['assets/images/pfood16-removebg-preview.png'],
        category: ProductCategory.food,
        stock: 10,
        brand: 'Ectote',
        weight: 22.0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: 'food17',
        name: 'Premium  Lizard Food',
        description: 'Nutritionally balanced Lizard food.',
        price: 30.99,
        rating: 5.0,
        imageUrls: ['assets/images/pfood17-removebg-preview.png'],
        category: ProductCategory.food,
        stock: 10,
        brand: 'Ectote',
        weight: 22.0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      // Toys
      Product(
        id: 'toy1',
        name: 'Chew Toy Set',
        description:
            'Durable chew toys to keep your dog entertained for hours.',
        price: 19.99,
        rating: 4.5,
        imageUrls: ['assets/images/stuffs33-removebg-preview.png'],
        category: ProductCategory.toys,
        stock: 25,
        brand: 'ChewMasters',
        weight: 1.5,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: 'toy2',
        name: 'Interactive Toy',
        description: 'Mental stimulation toy for smart dogs.',
        price: 29.99,
        rating: 4.8,
        imageUrls: ['assets/images/stuffs34-removebg-preview.png'],
        category: ProductCategory.toys,
        stock: 15,
        brand: 'BrainyPaws',
        weight: 3.0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: 'toy3',
        name: 'Rabbit Chew Toy Set',
        description:
            'Durable chew toys to keep your rabbit entertained for hours.',
        price: 19.99,
        rating: 4.5,
        imageUrls: ['assets/images/stuffs35-removebg-preview.png'],
        category: ProductCategory.toys,
        stock: 25,
        brand: 'ChewMasters',
        weight: 1.5,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: 'toy4',
        name: 'Rabbit Chew Toy Set',
        description:
            'Durable chew toys to keep your rabbit entertained for hours.',
        price: 19.99,
        rating: 4.5,
        imageUrls: ['assets/images/stuffs36-removebg-preview.png'],
        category: ProductCategory.toys,
        stock: 25,
        brand: 'ChewMasters',
        weight: 1.5,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: 'toy6',
        name: 'Dog Chew Toy Set',
        description:
            'Durable chew toys to keep your dog entertained for hours.',
        price: 19.99,
        rating: 4.5,
        imageUrls: ['assets/images/stuffs35-removebg-preview.png'],
        category: ProductCategory.toys,
        stock: 25,
        brand: 'ChewMasters',
        weight: 1.5,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: 'toy7',
        name: 'Dog Chew Toy Set',
        description:
            'Durable chew toys to keep your dog entertained for hours.',
        price: 19.99,
        rating: 4.5,
        imageUrls: ['assets/images/stuffs33-removebg-preview.png'],
        category: ProductCategory.toys,
        stock: 25,
        brand: 'ChewMasters',
        weight: 1.5,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: 'toy5',
        name: 'Dog Chew Toy Set',
        description:
            'Durable chew toys to keep your dog entertained for hours.',
        price: 19.99,
        rating: 4.5,
        imageUrls: ['assets/images/stuffs32-removebg-preview.png'],
        category: ProductCategory.toys,
        stock: 25,
        brand: 'ChewMasters',
        weight: 1.5,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: 'toy6',
        name: 'Cat Toy Set',
        description: 'Durable toys to keep your cat entertained for hours.',
        price: 20.99,
        rating: 3.5,
        imageUrls: ['assets/images/stuff40-removebg-preview.png'],
        category: ProductCategory.toys,
        stock: 25,
        brand: 'ChewMasters',
        weight: 1.5,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: 'toy7',
        name: 'Cat Toy Set',
        description: 'Durable toys to keep your cat entertained for hours.',
        price: 26.99,
        rating: 2.5,
        imageUrls: ['assets/images/stuff39-removebg-preview.png'],
        category: ProductCategory.toys,
        stock: 25,
        brand: 'ChewMasters',
        weight: 1.5,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      // Grooming
      Product(
        id: 'groom1',
        name: 'Pet Shampoo',
        description: 'Gentle shampoo for all pet types.',
        price: 15.99,
        rating: 4.6,
        imageUrls: ['assets/images/stuff17-removebg-preview.png'],
        category: ProductCategory.grooming,
        stock: 30,
        brand: 'CleanPaws',
        weight: 1.0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: 'groom2',
        name: 'Pet Care Kit',
        description: 'Gentle Kit for all pet types.',
        price: 25.99,
        rating: 3.6,
        imageUrls: ['assets/images/stuff18-removebg-preview.png'],
        category: ProductCategory.grooming,
        stock: 30,
        brand: 'CleanPaws',
        weight: 1.0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),

      Product(
        id: 'groom4',
        name: 'Dog Styling Kit',
        description: 'Gentle Styling lotion for all pet types.',
        price: 29.99,
        rating: 5.0,
        imageUrls: ['assets/images/stuff20-removebg-preview.png'],
        category: ProductCategory.grooming,
        stock: 20,
        brand: 'CleanPaws',
        weight: 1.0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: 'groom5',
        name: 'Dog Styling Lotion',
        description: 'Gentle Styling lotion for all pet types.',
        price: 29.99,
        rating: 5.0,
        imageUrls: ['assets/images/stuff20-removebg-preview.png'],
        category: ProductCategory.grooming,
        stock: 20,
        brand: 'CleanPaws',
        weight: 1.0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: 'groom6',
        name: 'Dog Styling Lotion',
        description: 'Gentle Styling lotion for all pet types.',
        price: 29.99,
        rating: 5.0,
        imageUrls: ['assets/images/stuff23-removebg-preview.png'],
        category: ProductCategory.grooming,
        stock: 20,
        brand: 'CleanPaws',
        weight: 1.0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      // Health
      Product(
        id: 'health1',
        name: 'Flea & Tick Treatment',
        description: 'Monthly protection against fleas and ticks.',
        price: 24.99,
        rating: 4.4,
        imageUrls: ['assets/images/stuff18-removebg-preview.png'],
        category: ProductCategory.health,
        stock: 20,
        brand: 'SafeGuard',
        weight: 0.5,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: 'groom3',
        name: 'Pet Care Kit',
        description: 'Gentle Kit for all pet types.',
        price: 25.99,
        rating: 3.6,
        imageUrls: ['assets/images/stuff19-removebg-preview.png'],
        category: ProductCategory.grooming,
        stock: 30,
        brand: 'CleanPaws',
        weight: 1.0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      // Accessories
      Product(
        id: 'acc1',
        name: 'Plush Dog Bed',
        description: 'Comfortable and cozy bed for your furry friend.',
        price: 39.99,
        rating: 4.8,
        imageUrls: ['assets/images/stuff5-removebg-preview.png'],
        category: ProductCategory.accessories,
        stock: 15,
        brand: 'Pawfect Comfort',
        weight: 5.0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),

      Product(
        id: 'acc2',
        name: 'Dog Bed Set',
        description: 'Durable dog bed set for daily care.',
        price: 22.99,
        rating: 4.3,
        imageUrls: ['assets/images/stuff6-removebg-preview.png'],
        category: ProductCategory.accessories,
        stock: 40,
        brand: 'WalkSafe',
        weight: 1.0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: 'acc3',
        name: 'Dog Bed Set',
        description: 'Durable dog bed set for daily care.',
        price: 22.99,
        rating: 4.3,
        imageUrls: ['assets/images/stuff7-removebg-preview.png'],
        category: ProductCategory.accessories,
        stock: 40,
        brand: 'WalkSafe',
        weight: 1.0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: 'acc4',
        name: 'Pet Cage',
        description: 'Durable cage set for security.',
        price: 22.99,
        rating: 4.3,
        imageUrls: ['assets/images/stuff24-removebg-preview.png'],
        category: ProductCategory.accessories,
        stock: 40,
        brand: 'WalkSafe',
        weight: 1.0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: 'acc5',
        name: 'Pet Cage',
        description: 'Durable cage set for security.',
        price: 22.99,
        rating: 4.3,
        imageUrls: ['assets/images/stuff25-removebg-preview.png'],
        category: ProductCategory.accessories,
        stock: 40,
        brand: 'WalkSafe',
        weight: 1.0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: 'acc6',
        name: 'Pet Cage',
        description: 'Durable cage set for security.',
        price: 22.99,
        rating: 4.3,
        imageUrls: ['assets/images/stuff26-removebg-preview.png'],
        category: ProductCategory.accessories,
        stock: 40,
        brand: 'WalkSafe',
        weight: 1.0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: 'acc8',
        name: 'Pet bed',
        description: 'Durable cage set for security.',
        price: 29.99,
        rating: 4.3,
        imageUrls: ['assets/images/stuff27-removebg-preview.png'],
        category: ProductCategory.accessories,
        stock: 40,
        brand: 'WalkSafe',
        weight: 1.0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: 'acc7',
        name: 'Fish Bowl',
        description: 'Fish Bowl.',
        price: 22.99,
        rating: 3.3,
        imageUrls: ['assets/images/stuff28-removebg-preview.png'],
        category: ProductCategory.accessories,
        stock: 20,
        brand: 'WalkSafe',
        weight: 1.0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: 'acc8',
        name: 'Fish Bowl',
        description: 'Fish Bowl.',
        price: 22.99,
        rating: 3.3,
        imageUrls: ['assets/images/stuff29-removebg-preview.png'],
        category: ProductCategory.accessories,
        stock: 20,
        brand: 'WalkSafe',
        weight: 1.0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: 'acc9',
        name: 'Lizard Cage',
        description: 'Lizard Cage.',
        price: 32.99,
        rating: 3.3,
        imageUrls: ['assets/images/stuff30-removebg-preview.png'],
        category: ProductCategory.accessories,
        stock: 20,
        brand: 'WalkSafe',
        weight: 1.0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: 'acc10',
        name: 'Lizard Cage',
        description: 'Lizard Cage.',
        price: 39.99,
        rating: 2.3,
        imageUrls: ['assets/images/stuff31-removebg-preview.png'],
        category: ProductCategory.accessories,
        stock: 90,
        brand: 'WalkSafe',
        weight: 1.0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      // Clothing
      Product(
        id: 'cloth1',
        name: 'Dog Hoodie - Blue',
        description: 'Comfortable and stylish blue hoodie for your dog.',
        price: 24.99,
        rating: 4.7,
        imageUrls: ['assets/images/shirt1-removebg-preview.png'],
        category: ProductCategory.clothing,
        stock: 15,
        brand: 'PetStyle',
        weight: 0.3,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: 'cloth2',
        name: 'Dog T-Shirt - Red',
        description: 'Classic red t-shirt perfect for casual wear.',
        price: 19.99,
        rating: 4.5,
        imageUrls: ['assets/images/shirt2-removebg-preview.png'],
        category: ProductCategory.clothing,
        stock: 20,
        brand: 'PetStyle',
        weight: 0.2,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: 'cloth3',
        name: 'Dog Hoodie - Green',
        description: 'Warm green hoodie for cooler weather.',
        price: 26.99,
        rating: 4.8,
        imageUrls: ['assets/images/shirt3-removebg-preview.png'],
        category: ProductCategory.clothing,
        stock: 12,
        brand: 'PetStyle',
        weight: 0.3,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: 'cloth4',
        name: 'Dog T-Shirt - Yellow',
        description: 'Bright yellow t-shirt for sunny days.',
        price: 18.99,
        rating: 4.3,
        imageUrls: ['assets/images/shirt4-removebg-preview.png'],
        category: ProductCategory.clothing,
        stock: 25,
        brand: 'PetStyle',
        weight: 0.2,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: 'cloth5',
        name: 'Dog Hoodie - Purple',
        description: 'Trendy purple hoodie for fashion-forward pets.',
        price: 27.99,
        rating: 4.6,
        imageUrls: ['assets/images/shirt5-removebg-preview.png'],
        category: ProductCategory.clothing,
        stock: 18,
        brand: 'PetStyle',
        weight: 0.3,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: 'cloth6',
        name: 'Dog T-Shirt - Orange',
        description: 'Vibrant orange t-shirt for active dogs.',
        price: 21.99,
        rating: 4.4,
        imageUrls: ['assets/images/shirt6-removebg-preview.png'],
        category: ProductCategory.clothing,
        stock: 22,
        brand: 'PetStyle',
        weight: 0.2,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: 'cloth7',
        name: 'Dog Hoodie - Pink',
        description: 'Cute pink hoodie perfect for smaller breeds.',
        price: 25.99,
        rating: 4.9,
        imageUrls: ['assets/images/shirt7-removebg-preview.png'],
        category: ProductCategory.clothing,
        stock: 16,
        brand: 'PetStyle',
        weight: 0.3,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: 'cloth8',
        name: 'Dog T-Shirt - Navy',
        description: 'Classic navy t-shirt for everyday wear.',
        price: 20.99,
        rating: 4.2,
        imageUrls: ['assets/images/shirt8-removebg-preview.png'],
        category: ProductCategory.clothing,
        stock: 30,
        brand: 'PetStyle',
        weight: 0.2,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: 'cloth9',
        name: 'Dog Hoodie - Black',
        description: 'Sleek black hoodie for sophisticated pets.',
        price: 28.99,
        rating: 4.7,
        imageUrls: ['assets/images/shirt9-removebg-preview.png'],
        category: ProductCategory.clothing,
        stock: 14,
        brand: 'PetStyle',
        weight: 0.3,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: 'cloth10',
        name: 'Dog T-Shirt - White',
        description: 'Clean white t-shirt for summer days.',
        price: 17.99,
        rating: 4.1,
        imageUrls: ['assets/images/shirt10-removebg-preview.png'],
        category: ProductCategory.clothing,
        stock: 35,
        brand: 'PetStyle',
        weight: 0.2,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: 'cloth11',
        name: 'Dog Hoodie - Gray',
        description: 'Versatile gray hoodie for any occasion.',
        price: 26.99,
        rating: 4.5,
        imageUrls: ['assets/images/shirt11-removebg-preview.png'],
        category: ProductCategory.clothing,
        stock: 19,
        brand: 'PetStyle',
        weight: 0.3,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: 'cloth12',
        name: 'Dog T-Shirt - Teal',
        description: 'Fresh teal t-shirt for outdoor adventures.',
        price: 22.99,
        rating: 4.6,
        imageUrls: ['assets/images/shirt12-removebg-preview.png'],
        category: ProductCategory.clothing,
        stock: 17,
        brand: 'PetStyle',
        weight: 0.2,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: 'cloth13',
        name: 'Dog Hoodie - Maroon',
        description: 'Rich maroon hoodie for winter comfort.',
        price: 29.99,
        rating: 4.8,
        imageUrls: ['assets/images/shirt13-removebg-preview.png'],
        category: ProductCategory.clothing,
        stock: 13,
        brand: 'PetStyle',
        weight: 0.3,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];

    ref.read(productNotifierProvider.notifier).setProducts(products);
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(productNotifierProvider);
    final filteredProducts = _getFilteredProducts(products);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CustomAppBar(
        title: 'Pet Store',
        cartWidget: Consumer(
          builder: (context, ref, child) {
            final cartItems = ref.watch(cartNotifierProvider);
            final itemCount = cartItems.fold(
              0,
              (sum, item) => sum + item.quantity,
            );
            return Badge(
              isLabelVisible: itemCount > 0,
              label: Text('$itemCount'),
              child: IconButton(
                icon: const Icon(Iconsax.shopping_cart),
                onPressed: () => context.go('/cart'),
              ),
            );
          },
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Iconsax.search_normal),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),

          // Category Filter
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    selectedColor: AppTheme.primaryColor.withValues(alpha: 0.2),
                    checkmarkColor: AppTheme.primaryColor,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? AppTheme.primaryColor
                          : Colors.grey[600],
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Products Grid
          Expanded(
            child: filteredProducts.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Iconsax.search_normal,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No products found',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.7,
                        ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return ProductCard(
                        product: product,
                        onTap: () {
                          context.push(
                            '/product/${product.id}',
                            extra: product.toJson(),
                          );
                        },
                        onAddToCart: () {
                          ref
                              .read(cartNotifierProvider.notifier)
                              .addToCart(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${product.name} added to cart'),
                              backgroundColor: AppTheme.primaryColor,
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  List<Product> _getFilteredProducts(List<Product> products) {
    List<Product> filtered = products;

    // Filter by category
    if (_selectedCategory != 'All') {
      final category = ProductCategory.values.firstWhere(
        (e) => e.name.toLowerCase() == _selectedCategory.toLowerCase(),
        orElse: () => ProductCategory.other,
      );
      filtered = filtered.where((p) => p.category == category).toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((product) {
        return product.name.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            ) ||
            product.description.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            ) ||
            (product.brand?.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ) ??
                false);
      }).toList();
    }

    return filtered;
  }
}
