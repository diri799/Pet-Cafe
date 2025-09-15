import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pawfect_care/features/products/models/product_model.dart';
import 'package:pawfect_care/features/products/providers/product_provider.dart';
import 'package:pawfect_care/features/products/widgets/product_card.dart';

class ProductsScreen extends ConsumerStatefulWidget {
  final String? category;
  final String? searchQuery;
  
  const ProductsScreen({
    super.key,
    this.category,
    this.searchQuery,
  });

  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  final ScrollController _scrollController = ScrollController();
  String _sortBy = 'featured';
  String _selectedCategory = 'all';
  final TextEditingController _searchController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      _selectedCategory = widget.category!;
    }
    if (widget.searchQuery != null) {
      _searchController.text = widget.searchQuery!;
    }
    
    _scrollController.addListener(_onScroll);
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }
  
  void _onScroll() {
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent - 200) {
      // Load more products when scrolled near the bottom
      // TODO: Implement pagination
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearchDialog,
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterBottomSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Category Dropdown
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    items: [
                      const DropdownMenuItem(
                        value: 'all',
                        child: Text('All Categories'),
                      ),
                      ...ProductCategory.values.map((category) {
                        return DropdownMenuItem(
                          value: category.toString().split('.').last,
                          child: Text(category.displayName),
                        );
                      }).toList(),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                // Sort Button
                PopupMenuButton<String>(
                  onSelected: (value) {
                    setState(() {
                      _sortBy = value;
                    });
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'featured',
                      child: Text('Featured'),
                    ),
                    const PopupMenuItem(
                      value: 'price_low',
                      child: Text('Price: Low to High'),
                    ),
                    const PopupMenuItem(
                      value: 'price_high',
                      child: Text('Price: High to Low'),
                    ),
                    const PopupMenuItem(
                      value: 'newest',
                      child: Text('Newest'),
                    ),
                    const PopupMenuItem(
                      value: 'rating',
                      child: Text('Top Rated'),
                    ),
                  ],
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.sort, size: 20),
                        SizedBox(width: 4),
                        Text('Sort'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Products Grid
          Expanded(
            child: _buildProductsList(),
          ),
        ],
      ),
    );
  }
  
  Widget _buildProductsList() {
    // Get products stream based on filters
    final productsStream = _getFilteredProductsStream();
    
    return StreamBuilder<List<Product>>(
      stream: productsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error loading products: ${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Retry loading products
                    setState(() {});
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        
        final products = snapshot.data ?? [];
        
        if (products.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off_rounded, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No products found',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Try adjusting your search or filter criteria',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }
        
        // Sort products based on selected option
        final sortedProducts = _sortProducts(products);
        
        return GridView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: sortedProducts.length,
          itemBuilder: (context, index) {
            final product = sortedProducts[index];
            return ProductCard(
              product: product,
              onTap: () {
                // Navigate to product detail
                Navigator.pushNamed(context, '/product/${product.id}', arguments: product);
              },
            );
          },
        );
      },
    );
  }
  
  Stream<List<Product>> _getFilteredProductsStream() {
    final productNotifier = ref.read(productNotifierProvider.notifier);
    
    if (_searchController.text.isNotEmpty) {
      return Stream.value(productNotifier.searchProducts(_searchController.text));
    }
    
    if (_selectedCategory != 'all') {
      final category = ProductCategory.values.firstWhere(
        (c) => c.toString().split('.').last == _selectedCategory,
        orElse: () => ProductCategory.other,
      );
      return Stream.value(productNotifier.getProductsByCategory(category));
    }
    
    // Default: Get featured products
    return Stream.value(ref.read(featuredProductsProvider));
  }
  
  List<Product> _sortProducts(List<Product> products) {
    switch (_sortBy) {
      case 'price_low':
        return List.from(products)..sort((a, b) => a.price.compareTo(b.price));
      case 'price_high':
        return List.from(products)..sort((a, b) => b.price.compareTo(a.price));
      case 'newest':
        return List.from(products)
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      case 'rating':
        return List.from(products)
          ..sort((a, b) => b.rating!.compareTo(a.rating!));
      case 'featured':
      default:
        // Featured products first, then by name
        return List.from(products)
          ..sort((a, b) {
            if (a.isFeatured && !b.isFeatured) return -1;
            if (!a.isFeatured && b.isFeatured) return 1;
            return a.name.compareTo(b.name);
          });
    }
  }
  
  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Products'),
        content: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search by name, category...',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(),
          ),
          onSubmitted: (value) {
            Navigator.pop(context);
            setState(() {});
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              _searchController.clear();
              Navigator.pop(context);
              setState(() {});
            },
            child: const Text('Clear'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {});
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }
  
  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filter Products',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            // Price Range
            const Text('Price Range', style: TextStyle(fontWeight: FontWeight.bold)),
            // TODO: Add price range slider
            
            const SizedBox(height: 16),
            
            // In Stock Only
            Row(
              children: [
                Checkbox(value: false, onChanged: (value) {}),
                const Text('In Stock Only'),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Apply Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {});
                },
                child: const Text('Apply Filters'),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  // Reset all filters
                  _searchController.clear();
                  _selectedCategory = 'all';
                  _sortBy = 'featured';
                  Navigator.pop(context);
                  setState(() {});
                },
                child: const Text('Reset Filters'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

