import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pawfect_care/core/theme/app_theme.dart';
import 'package:pawfect_care/core/services/user_service.dart';
import 'package:pawfect_care/core/services/auth_service.dart';

class ShelterDashboard extends StatefulWidget {
  const ShelterDashboard({super.key});

  @override
  State<ShelterDashboard> createState() => _ShelterDashboardState();
}

class _ShelterDashboardState extends State<ShelterDashboard> {
  int _currentIndex = 0;
  final _userService = UserService();
  Map<String, dynamic>? _userData;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<Map<String, dynamic>> _filteredPets = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _searchController.addListener(_onSearchChanged);
    _filteredPets = _getMockPets();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
      _filteredPets = _getMockPets().where((pet) {
        final petName = (pet['name'] ?? '').toLowerCase();
        final breed = (pet['breed'] ?? '').toLowerCase();
        final species = (pet['species'] ?? '').toLowerCase();
        final status = (pet['status'] ?? '').toLowerCase();
        return petName.contains(_searchQuery) ||
               breed.contains(_searchQuery) ||
               species.contains(_searchQuery) ||
               status.contains(_searchQuery);
      }).toList();
    });
  }

  void _loadUserData() {
    final user = _userService.currentUser;
    if (user != null) {
      setState(() {
        _userData = user;
      });
    }
  }

  String _getUserDisplayName() {
    if (_userData != null) {
      return _userData!['name'] ?? 'Shelter Admin';
    }
    return 'Shelter Admin';
  }

  String _getUserEmail() {
    if (_userData != null) {
      return _userData!['email'] ?? 'admin@shelter.com';
    }
    return 'admin@shelter.com';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Shelter Management'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Iconsax.notification),
            onPressed: () => context.go('/notification-settings'),
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildAdoptionManagementTab(),
          _buildCommunicationTab(),
          _buildShopManagementTab(),
          _buildResourcesTab(),
          _buildProfileTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: Colors.grey[500],
        items: const [
          BottomNavigationBarItem(icon: Icon(Iconsax.heart), label: 'Adoptions'),
          BottomNavigationBarItem(icon: Icon(Iconsax.message), label: 'Messages'),
          BottomNavigationBarItem(icon: Icon(Iconsax.shop), label: 'Shop'),
          BottomNavigationBarItem(icon: Icon(Iconsax.document_text), label: 'Resources'),
          BottomNavigationBarItem(icon: Icon(Iconsax.profile_circle), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildAdoptionManagementTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick Stats
          Row(
            children: [
              Expanded(child: _buildStatCard('Available', '8', Iconsax.heart, Colors.green)),
              const SizedBox(width: 16),
              Expanded(child: _buildStatCard('Adopted', '24', Iconsax.tick_circle, Colors.blue)),
              const SizedBox(width: 16),
              Expanded(child: _buildStatCard('Pending', '5', Iconsax.clock, Colors.orange)),
            ],
          ),
          const SizedBox(height: 24),
          
          // Search Bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search pets...',
              prefixIcon: const Icon(Iconsax.search_normal),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Colors.white,
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                      },
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 24),
          
          // Add New Pet Button
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primaryColor, AppTheme.primaryColor.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: () => _showAddPetDialog(),
              icon: const Icon(Iconsax.add_circle, size: 24),
              label: const Text('Add New Pet for Adoption', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Available Pets
          Text(
            _searchQuery.isNotEmpty 
                ? 'Search Results (${_filteredPets.length})' 
                : 'Available for Adoption',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
          ),
          const SizedBox(height: 16),
          _buildPetCards(),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
          Text(title, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getMockPets() {
    return [
      {
        'id': '1',
        'name': 'Luna',
        'breed': 'Labrador Mix',
        'age': '2 years',
        'gender': 'Female',
        'status': 'available',
        'image': 'assets/images/sale1-removebg-preview.png',
        'color': Colors.amber,
        'description': 'Friendly and energetic, loves playing fetch',
        'health': 'Vaccinated, spayed, healthy',
        'arrivalDate': '2024-01-05',
      },
      {
        'id': '2',
        'name': 'Rocky',
        'breed': 'German Shepherd',
        'age': '4 years',
        'gender': 'Male',
        'status': 'pending',
        'image': 'assets/images/sale2-removebg-preview.png',
        'color': Colors.blue,
        'description': 'Loyal and protective, great with families',
        'health': 'Vaccinated, neutered, healthy',
        'arrivalDate': '2024-01-08',
      },
      {
        'id': '3',
        'name': 'Mittens',
        'breed': 'Persian Cat',
        'age': '1 year',
        'gender': 'Female',
        'status': 'available',
        'image': 'assets/images/sale3-removebg-preview.png',
        'color': Colors.purple,
        'description': 'Calm and affectionate, perfect lap cat',
        'health': 'Vaccinated, spayed, healthy',
        'arrivalDate': '2024-01-10',
      },
      {
        'id': '4',
        'name': 'Buddy',
        'breed': 'Golden Retriever',
        'age': '3 years',
        'gender': 'Male',
        'status': 'available',
        'image': 'assets/images/sale4-removebg-preview.png',
        'color': Colors.green,
        'description': 'Playful and social, loves water activities',
        'health': 'Vaccinated, neutered, healthy',
        'arrivalDate': '2024-01-12',
      },
    ];
  }

  Widget _buildPetCards() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _filteredPets.length,
      itemBuilder: (context, index) {
        final pet = _filteredPets[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: (pet['color'] as Color).withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: (pet['color'] as Color).withOpacity(0.2)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Pet Header with Image and Info
                Row(
                  children: [
                    // Pet Image with Decorative Border
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: (pet['color'] as Color).withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          pet['image'] as String,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: (pet['color'] as Color).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              Icons.pets,
                              color: pet['color'] as Color,
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                pet['name'] as String,
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _getPetEmoji(pet['breed'] as String),
                                style: const TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${pet['breed']} • ${pet['age']} • ${pet['gender']}',
                            style: TextStyle(fontSize: 14, color: Colors.grey[600], fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Arrived: ${pet['arrivalDate']}',
                            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getStatusColor(pet['status'] as String).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: _getStatusColor(pet['status'] as String).withOpacity(0.3)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _getStatusIcon(pet['status'] as String),
                                  size: 12,
                                  color: _getStatusColor(pet['status'] as String),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  (pet['status'] as String).toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: _getStatusColor(pet['status'] as String),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Pet Description and Health
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 8),
                          const Text('Description', style: TextStyle(fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(pet['description'] as String, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.health_and_safety, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 8),
                          const Text('Health Status', style: TextStyle(fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(pet['health'] as String, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
                        ),
                        child: OutlinedButton.icon(
                          onPressed: () => _editPet(pet),
                          icon: const Icon(Iconsax.edit, size: 16),
                          label: const Text('Edit Pet'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.primaryColor,
                            side: BorderSide.none,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.green, Colors.green.withOpacity(0.8)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () => _viewApplications(pet),
                          icon: const Icon(Iconsax.eye, size: 16),
                          label: const Text('Applications'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCommunicationTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Communication Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Communication Center', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: () => _showNewMessageDialog(),
                  icon: const Icon(Iconsax.message_add, color: AppTheme.primaryColor),
                  tooltip: 'New Message',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Communication Categories
          Row(
            children: [
              Expanded(
                child: _buildCommunicationCard(
                  'Veterinarians',
                  Iconsax.health,
                  Colors.blue,
                  '5 Active',
                  () => _showVetMessages(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildCommunicationCard(
                  'Pet Owners',
                  Iconsax.heart,
                  Colors.green,
                  '12 Conversations',
                  () => _showOwnerMessages(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Recent Messages
          const Text('Recent Messages', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          _buildMessageList(),
        ],
      ),
    );
  }

  Widget _buildCommunicationCard(String title, IconData icon, Color color, String subtitle, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 12),
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: color)),
            const SizedBox(height: 4),
            Text(subtitle, style: TextStyle(fontSize: 12, color: color.withOpacity(0.8))),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageList() {
    final messages = [
      {
        'sender': 'Dr. Sarah Wilson',
        'type': 'Veterinarian',
        'message': 'Luna\'s health checkup is scheduled for tomorrow',
        'time': '2 hours ago',
        'color': Colors.blue,
      },
      {
        'sender': 'John Doe',
        'type': 'Pet Owner',
        'message': 'Interested in adopting Rocky, when can we meet?',
        'time': '4 hours ago',
        'color': Colors.green,
      },
      {
        'sender': 'Dr. Mike Johnson',
        'type': 'Veterinarian',
        'message': 'Mittens is ready for adoption after final vaccination',
        'time': '1 day ago',
        'color': Colors.blue,
      },
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 8, offset: const Offset(0, 2))],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (message['color'] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  message['type'] == 'Veterinarian' ? Iconsax.health : Iconsax.heart,
                  color: message['color'] as Color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message['sender'] as String,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      message['message'] as String,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message['time'] as String,
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _replyToMessage(message),
                icon: const Icon(Iconsax.message, color: AppTheme.primaryColor),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShopManagementTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Shop Management Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Shop Management', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.primaryColor, AppTheme.primaryColor.withOpacity(0.8)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: () => _showAddProductDialog(),
                  icon: const Icon(Iconsax.add, color: Colors.white),
                  tooltip: 'Add Product',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Shop Stats
          Row(
            children: [
              Expanded(child: _buildStatCard('Products', '45', Iconsax.shop, Colors.purple)),
              const SizedBox(width: 16),
              Expanded(child: _buildStatCard('Sales', '128', Iconsax.money_send, Colors.green)),
              const SizedBox(width: 16),
              Expanded(child: _buildStatCard('Revenue', '\$2,450', Iconsax.dollar_circle, Colors.blue)),
            ],
          ),
          const SizedBox(height: 24),
          
          // Product Categories
          const Text('Product Categories', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          _buildProductCategories(),
          const SizedBox(height: 24),
          
          // Recent Products
          const Text('Recent Products', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          _buildProductList(),
        ],
      ),
    );
  }

  Widget _buildProductCategories() {
    final categories = [
      {'name': 'Pet Food', 'icon': Iconsax.cake, 'color': Colors.orange, 'count': '15'},
      {'name': 'Toys', 'icon': Iconsax.game, 'color': Colors.pink, 'count': '12'},
      {'name': 'Accessories', 'icon': Iconsax.crown, 'color': Colors.purple, 'count': '8'},
      {'name': 'Health', 'icon': Iconsax.health, 'color': Colors.green, 'count': '10'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return GestureDetector(
          onTap: () => _viewCategoryProducts(category['name'] as String),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: (category['color'] as Color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: (category['color'] as Color).withOpacity(0.2)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(category['icon'] as IconData, color: category['color'] as Color, size: 32),
                const SizedBox(height: 12),
                Text(
                  category['name'] as String,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: category['color'] as Color),
                ),
                const SizedBox(height: 4),
                Text(
                  '${category['count']} items',
                  style: TextStyle(fontSize: 12, color: (category['color'] as Color).withOpacity(0.8)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductList() {
    final products = [
      {
        'name': 'Premium Dog Food',
        'price': '\$24.99',
        'stock': '45',
        'image': 'assets/images/pfood1-removebg-preview.png',
        'color': Colors.orange,
      },
      {
        'name': 'Cat Toy Set',
        'price': '\$12.99',
        'stock': '23',
        'image': 'assets/images/pfood2-removebg-preview.png',
        'color': Colors.pink,
      },
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 8, offset: const Offset(0, 2))],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  product['image'] as String,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 60,
                    height: 60,
                    color: (product['color'] as Color).withOpacity(0.1),
                    child: Icon(Icons.shopping_bag, color: product['color'] as Color, size: 30),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product['name'] as String, style: const TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text('Price: ${product['price']}', style: TextStyle(color: Colors.grey[600])),
                    Text('Stock: ${product['stock']}', style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () => _editProduct(product),
                    icon: const Icon(Iconsax.edit, color: AppTheme.primaryColor),
                  ),
                  IconButton(
                    onPressed: () => _deleteProduct(product),
                    icon: const Icon(Iconsax.trash, color: Colors.red),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildResourcesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Educational Resources', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          
          // Resource Categories
          Row(
            children: [
              Expanded(
                child: _buildResourceCard(
                  'Blog Articles',
                  Iconsax.document_text,
                  Colors.blue,
                  'Access educational content',
                  () => context.go('/shelter-blog'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildResourceCard(
                  'Animal Videos',
                  Iconsax.video,
                  Colors.green,
                  'Watch training videos',
                  () => context.go('/shelter-animal-feed'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Quick Access Tools
          const Text('Quick Access Tools', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          _buildQuickAccessTools(),
        ],
      ),
    );
  }

  Widget _buildResourceCard(String title, IconData icon, Color color, String subtitle, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 40),
            const SizedBox(height: 12),
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: color)),
            const SizedBox(height: 4),
            Text(subtitle, style: TextStyle(fontSize: 12, color: color.withOpacity(0.8))),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccessTools() {
    final tools = [
      {'name': 'Adoption Forms', 'icon': Iconsax.document_text, 'color': Colors.orange},
      {'name': 'Health Records', 'icon': Iconsax.health, 'color': Colors.green},
      {'name': 'Volunteer Schedule', 'icon': Iconsax.calendar, 'color': Colors.blue},
      {'name': 'Donation Tracker', 'icon': Iconsax.money_send, 'color': Colors.purple},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: tools.length,
      itemBuilder: (context, index) {
        final tool = tools[index];
        return GestureDetector(
          onTap: () => _showToolDialog(tool['name'] as String),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: (tool['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(tool['icon'] as IconData, color: tool['color'] as Color, size: 24),
                ),
                const SizedBox(height: 12),
                Text(
                  tool['name'] as String,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Profile Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: AppTheme.primaryColor,
                  child: Icon(Icons.home, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 16),
                Text(_getUserDisplayName(), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Shelter Administrator', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                Text(_getUserEmail(), style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildProfileStat('Pets', '32'),
                    _buildProfileStat('Adopted', '156'),
                    _buildProfileStat('Volunteers', '25'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Profile Options
          _buildProfileOptions(),
        ],
      ),
    );
  }

  Widget _buildProfileStat(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildProfileOptions() {
    final options = [
      {'icon': Iconsax.edit, 'title': 'Edit Profile', 'onTap': () => context.go('/edit-profile')},
      {'icon': Iconsax.setting_2, 'title': 'Settings', 'onTap': () => context.go('/settings')},
      {'icon': Iconsax.notification, 'title': 'Notifications', 'onTap': () => context.go('/notification-settings')},
      {'icon': Iconsax.logout, 'title': 'Logout', 'onTap': () => _performLogout(context)},
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: options.length,
      itemBuilder: (context, index) {
        final option = options[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 4, offset: const Offset(0, 2))],
          ),
          child: ListTile(
            leading: Icon(option['icon'] as IconData, color: AppTheme.primaryColor),
            title: Text(option['title'] as String, style: const TextStyle(fontWeight: FontWeight.w500)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: option['onTap'] as VoidCallback,
          ),
        );
      },
    );
  }

  // Helper methods
  String _getPetEmoji(String breed) {
    if (breed.toLowerCase().contains('dog') || breed.toLowerCase().contains('retriever') || breed.toLowerCase().contains('shepherd') || breed.toLowerCase().contains('labrador')) {
      return '🐕';
    } else if (breed.toLowerCase().contains('cat') || breed.toLowerCase().contains('persian')) {
      return '🐱';
    } else {
      return '🐾';
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'adopted':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return Icons.check_circle;
      case 'pending':
        return Icons.schedule;
      case 'adopted':
        return Icons.favorite;
      default:
        return Icons.help;
    }
  }

  // Dialog methods
  void _showAddPetDialog() {
    final nameController = TextEditingController();
    final breedController = TextEditingController();
    final ageController = TextEditingController();
    final descriptionController = TextEditingController();
    final adoptionFeeController = TextEditingController();
    String selectedSpecies = 'Dog';
    String selectedGender = 'Male';
    String selectedHealthStatus = 'Healthy';
    String selectedTemperament = 'Friendly';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add New Pet'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Pet Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedSpecies,
                  decoration: const InputDecoration(
                    labelText: 'Species',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Dog', 'Cat', 'Bird', 'Rabbit', 'Other'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedSpecies = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: breedController,
                  decoration: const InputDecoration(
                    labelText: 'Breed',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: ageController,
                  decoration: const InputDecoration(
                    labelText: 'Age (years)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedGender,
                  decoration: const InputDecoration(
                    labelText: 'Gender',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Male', 'Female'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedGender = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedHealthStatus,
                  decoration: const InputDecoration(
                    labelText: 'Health Status',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Healthy', 'Sick', 'Recovering', 'Special Needs'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedHealthStatus = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedTemperament,
                  decoration: const InputDecoration(
                    labelText: 'Temperament',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Friendly', 'Calm', 'Energetic', 'Shy', 'Playful', 'Protective'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedTemperament = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: adoptionFeeController,
                  decoration: const InputDecoration(
                    labelText: 'Adoption Fee (\$)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty && breedController.text.isNotEmpty) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${nameController.text} has been added to the shelter!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in pet name and breed'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Add Pet'),
            ),
          ],
        ),
      ),
    );
  }

  void _showNewMessageDialog() {
    final recipientController = TextEditingController();
    final subjectController = TextEditingController();
    final messageController = TextEditingController();
    String selectedRecipientType = 'Pet Owner';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('New Message'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedRecipientType,
                  decoration: const InputDecoration(
                    labelText: 'Recipient Type',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Pet Owner', 'Veterinarian', 'Volunteer', 'Staff'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedRecipientType = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: recipientController,
                  decoration: const InputDecoration(
                    labelText: 'Recipient Name/Email',
                    border: OutlineInputBorder(),
                    hintText: 'Enter name or email address',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: subjectController,
                  decoration: const InputDecoration(
                    labelText: 'Subject',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: messageController,
                  decoration: const InputDecoration(
                    labelText: 'Message',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (recipientController.text.isNotEmpty && subjectController.text.isNotEmpty && messageController.text.isNotEmpty) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Message sent to ${recipientController.text}'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in all fields'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Send Message'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddProductDialog() {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final stockController = TextEditingController();
    final descriptionController = TextEditingController();
    String selectedCategory = 'Pet Food';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Product'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Product Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Pet Food', 'Toys', 'Accessories', 'Health Care', 'Grooming'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCategory = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(
                    labelText: 'Price (\$)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: stockController,
                  decoration: const InputDecoration(
                    labelText: 'Stock Quantity',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty && priceController.text.isNotEmpty && stockController.text.isNotEmpty) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${nameController.text} has been added to inventory!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in all required fields'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Add Product'),
            ),
          ],
        ),
      ),
    );
  }

  void _showToolDialog(String toolName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(toolName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (toolName == 'Adoption Forms') ...[
              const Text('Manage adoption applications and forms.'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showAdoptionForms();
                },
                child: const Text('View Forms'),
              ),
            ] else if (toolName == 'Health Records') ...[
              const Text('Access and manage pet health records.'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showHealthRecords();
                },
                child: const Text('View Records'),
              ),
            ] else if (toolName == 'Volunteer Schedule') ...[
              const Text('Manage volunteer schedules and assignments.'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showVolunteerSchedule();
                },
                child: const Text('View Schedule'),
              ),
            ] else if (toolName == 'Donation Tracker') ...[
              const Text('Track donations and funding.'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showDonationTracker();
                },
                child: const Text('View Donations'),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAdoptionForms() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Adoption Forms'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Iconsax.document_text),
              title: const Text('Application Form'),
              subtitle: const Text('5 pending applications'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Application form opened')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Iconsax.health),
              title: const Text('Health Check Form'),
              subtitle: const Text('3 pending health checks'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Health check form opened')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Iconsax.home),
              title: const Text('Home Visit Form'),
              subtitle: const Text('2 scheduled visits'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Home visit form opened')),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showHealthRecords() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Health Records'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('🏥 Pet Health Overview'),
            SizedBox(height: 8),
            Text('📊 Total Pets: 32'),
            Text('💉 Vaccinations Due: 8'),
            Text('🏥 Medical Checkups: 12'),
            Text('💊 Medications: 5'),
            Text('📅 Next Vet Visit: Tomorrow'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showVolunteerSchedule() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Volunteer Schedule'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Iconsax.calendar),
              title: const Text('Today\'s Schedule'),
              subtitle: const Text('8 volunteers scheduled'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Today\'s schedule opened')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Iconsax.user),
              title: const Text('Volunteer Roster'),
              subtitle: const Text('25 active volunteers'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Volunteer roster opened')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Iconsax.add_circle),
              title: const Text('Add Volunteer'),
              subtitle: const Text('Register new volunteer'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Add volunteer form opened')),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showDonationTracker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Donation Tracker'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('💰 Donation Summary'),
            SizedBox(height: 8),
            Text('📊 This Month: \$2,450'),
            Text('📈 Last Month: \$1,890'),
            Text('🎯 Goal: \$3,000'),
            Text('📅 Next Fundraiser: Next Friday'),
            Text('💝 Top Donor: John Smith (\$500)'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  // Action methods
  void _editPet(Map<String, dynamic> pet) {
    final nameController = TextEditingController(text: pet['name'] ?? '');
    final breedController = TextEditingController(text: pet['breed'] ?? '');
    final ageController = TextEditingController(text: pet['age']?.toString() ?? '');
    final descriptionController = TextEditingController(text: pet['description'] ?? '');
    final adoptionFeeController = TextEditingController(text: pet['adoptionFee']?.toString() ?? '');
    String selectedSpecies = pet['species'] ?? 'Dog';
    String selectedGender = pet['gender'] ?? 'Male';
    String selectedHealthStatus = pet['healthStatus'] ?? 'Healthy';
    String selectedTemperament = pet['temperament'] ?? 'Friendly';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Edit ${pet['name']}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Pet Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedSpecies,
                  decoration: const InputDecoration(
                    labelText: 'Species',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Dog', 'Cat', 'Bird', 'Rabbit', 'Other'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedSpecies = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: breedController,
                  decoration: const InputDecoration(
                    labelText: 'Breed',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: ageController,
                  decoration: const InputDecoration(
                    labelText: 'Age (years)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedGender,
                  decoration: const InputDecoration(
                    labelText: 'Gender',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Male', 'Female'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedGender = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedHealthStatus,
                  decoration: const InputDecoration(
                    labelText: 'Health Status',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Healthy', 'Sick', 'Recovering', 'Special Needs'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedHealthStatus = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedTemperament,
                  decoration: const InputDecoration(
                    labelText: 'Temperament',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Friendly', 'Calm', 'Energetic', 'Shy', 'Playful', 'Protective'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedTemperament = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: adoptionFeeController,
                  decoration: const InputDecoration(
                    labelText: 'Adoption Fee (\$)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty && breedController.text.isNotEmpty) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${nameController.text} information updated successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in pet name and breed'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Update Pet'),
            ),
          ],
        ),
      ),
    );
  }

  void _viewApplications(Map<String, dynamic> pet) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Applications for ${pet['name']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Iconsax.user),
              title: const Text('Sarah Johnson'),
              subtitle: const Text('Applied 2 days ago'),
              trailing: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Application approved!')),
                  );
                },
                child: const Text('Approve'),
              ),
            ),
            ListTile(
              leading: const Icon(Iconsax.user),
              title: const Text('Mike Chen'),
              subtitle: const Text('Applied 1 week ago'),
              trailing: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Application approved!')),
                  );
                },
                child: const Text('Approve'),
              ),
            ),
            ListTile(
              leading: const Icon(Iconsax.user),
              title: const Text('Emily Davis'),
              subtitle: const Text('Applied 3 days ago'),
              trailing: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Application approved!')),
                  );
                },
                child: const Text('Approve'),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showVetMessages() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Veterinarian Messages'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Iconsax.health),
              title: const Text('Dr. Sarah Wilson'),
              subtitle: const Text('Health check scheduled for Max'),
              trailing: const Text('2 min ago'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Message opened')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Iconsax.health),
              title: const Text('Dr. Mike Johnson'),
              subtitle: const Text('Vaccination records updated'),
              trailing: const Text('1 hour ago'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Message opened')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Iconsax.health),
              title: const Text('Dr. Emily Davis'),
              subtitle: const Text('Emergency consultation needed'),
              trailing: const Text('3 hours ago'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Message opened')),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showOwnerMessages() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pet Owner Messages'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Iconsax.user),
              title: const Text('John Smith'),
              subtitle: const Text('Interested in adopting Bella'),
              trailing: const Text('5 min ago'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Message opened')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Iconsax.user),
              title: const Text('Sarah Johnson'),
              subtitle: const Text('Questions about adoption process'),
              trailing: const Text('1 hour ago'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Message opened')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Iconsax.user),
              title: const Text('Mike Chen'),
              subtitle: const Text('Volunteer application submitted'),
              trailing: const Text('2 hours ago'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Message opened')),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _replyToMessage(Map<String, dynamic> message) {
    final replyController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reply to ${message['sender']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Original Message:',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 4),
                  Text(message['content'] ?? 'No content'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: replyController,
              decoration: const InputDecoration(
                labelText: 'Your Reply',
                border: OutlineInputBorder(),
                hintText: 'Type your response here...',
              ),
              maxLines: 4,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (replyController.text.isNotEmpty) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Reply sent to ${message['sender']}'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter a reply message'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Send Reply'),
          ),
        ],
      ),
    );
  }

  void _viewCategoryProducts(String category) {
    // Mock products for the category
    final products = {
      'Pet Food': [
        {'name': 'Premium Dog Food', 'price': 24.99, 'stock': 45, 'description': 'High-quality nutrition for adult dogs'},
        {'name': 'Cat Kibble', 'price': 18.99, 'stock': 32, 'description': 'Balanced diet for indoor cats'},
        {'name': 'Puppy Formula', 'price': 29.99, 'stock': 18, 'description': 'Special formula for growing puppies'},
      ],
      'Toys': [
        {'name': 'Interactive Ball', 'price': 12.99, 'stock': 25, 'description': 'Bouncing ball with sound effects'},
        {'name': 'Catnip Mouse', 'price': 8.99, 'stock': 40, 'description': 'Soft mouse toy with catnip'},
        {'name': 'Chew Bone', 'price': 15.99, 'stock': 30, 'description': 'Durable bone for teething puppies'},
      ],
      'Accessories': [
        {'name': 'Leash Set', 'price': 19.99, 'stock': 20, 'description': 'Adjustable leash with collar'},
        {'name': 'Cat Carrier', 'price': 35.99, 'stock': 12, 'description': 'Portable carrier for vet visits'},
        {'name': 'Food Bowl Set', 'price': 14.99, 'stock': 35, 'description': 'Stainless steel bowls for food and water'},
      ],
    };

    final categoryProducts = products[category] ?? [];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$category Products'),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: ListView.builder(
            itemCount: categoryProducts.length,
            itemBuilder: (context, index) {
              final product = categoryProducts[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  title: Text(product['name']?.toString() ?? 'Unknown Product'),
                  subtitle: Text('Price: \$${product['price']} | Stock: ${product['stock']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        onPressed: () {
                          Navigator.pop(context);
                          _editProduct(product);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${product['name']} deleted'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showAddProductDialog();
            },
            child: const Text('Add Product'),
          ),
        ],
      ),
    );
  }

  void _editProduct(Map<String, dynamic> product) {
    final nameController = TextEditingController(text: product['name'] ?? '');
    final priceController = TextEditingController(text: product['price']?.toString() ?? '');
    final stockController = TextEditingController(text: product['stock']?.toString() ?? '');
    final descriptionController = TextEditingController(text: product['description'] ?? '');
    String selectedCategory = 'Pet Food';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Edit ${product['name']}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Product Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Pet Food', 'Toys', 'Accessories', 'Health Care', 'Grooming'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCategory = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(
                    labelText: 'Price (\$)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: stockController,
                  decoration: const InputDecoration(
                    labelText: 'Stock Quantity',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty && priceController.text.isNotEmpty && stockController.text.isNotEmpty) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${nameController.text} updated successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in all required fields'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Update Product'),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteProduct(Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete ${product['name']}'),
        content: const Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _performLogout(BuildContext context) async {
    try {
      // Show loading indicator
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                SizedBox(width: 16),
                Text('Logging out...'),
              ],
            ),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.orange,
          ),
        );
      }

      // Clear user session
      final authService = AuthService();
      await authService.logout();

      // Small delay to show the loading message
      await Future.delayed(const Duration(milliseconds: 500));

      // Navigate to login screen
      if (context.mounted) {
        // Clear any existing snackbars
        ScaffoldMessenger.of(context).clearSnackBars();
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Successfully logged out'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 1),
          ),
        );
        
        // Navigate to login
        context.go('/login');
      }
    } catch (e) {
      // Show error message
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout failed: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}