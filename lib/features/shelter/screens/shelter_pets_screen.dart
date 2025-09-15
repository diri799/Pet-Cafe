import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pawfect_care/core/theme/app_theme.dart';

class ShelterPetsScreen extends StatefulWidget {
  const ShelterPetsScreen({super.key});

  @override
  State<ShelterPetsScreen> createState() => _ShelterPetsScreenState();
}

class _ShelterPetsScreenState extends State<ShelterPetsScreen> {
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Dogs',
    'Cats',
    'Small Animals',
    'Reptiles',
  ];

  final List<Map<String, dynamic>> _shelterPets = [
    {
      'id': '1',
      'name': 'Buddy',
      'species': 'Dog',
      'breed': 'Golden Retriever',
      'age': '2 years',
      'image': 'assets/images/sale1-removebg-preview.png',
      'health': 'Healthy',
      'foundDate': '2023-06-15',
      'activities': ['Playing fetch', 'Swimming', 'Meeting new people'],
      'description':
          'Buddy is a friendly and energetic golden retriever who loves to play and make new friends.',
      'adoptionStatus': 'Available',
    },
    {
      'id': '2',
      'name': 'Luna',
      'species': 'Cat',
      'breed': 'Siberian Husky',
      'age': '1.5 years',
      'image': 'assets/images/sale6-removebg-preview.png',
      'health': 'Healthy',
      'foundDate': '2023-08-20',
      'activities': ['Climbing', 'Playing with toys', 'Sunbathing'],
      'description':
          'Luna is a gentle and playful cat who enjoys quiet moments and interactive play.',
      'adoptionStatus': 'Available',
    },
    {
      'id': '3',
      'name': 'Charlie',
      'species': 'Dog',
      'breed': 'Beagle',
      'age': '3 years',
      'image': 'assets/images/sale3-removebg-preview.png',
      'health': 'Healthy',
      'foundDate': '2023-05-10',
      'activities': [
        'Sniffing around',
        'Playing with other dogs',
        'Going for walks',
      ],
      'description':
          'Charlie is a curious and friendly beagle who loves to explore and meet new friends.',
      'adoptionStatus': 'Available',
    },
    {
      'id': '5',
      'name': 'Nibbles',
      'species': 'Hamster',
      'breed': 'Syrian Hamster',
      'age': '6 months',
      'image': 'assets/images/sale29-removebg-preview.png',
      'health': 'Healthy',
      'foundDate': '2023-11-05',
      'activities': ['Running on wheel', 'Building nests', 'Eating seeds'],
      'description':
          'Nibbles is an active and curious hamster who loves to explore and play.',
      'adoptionStatus': 'Available',
    },
    {
      'id': '6',
      'name': 'Spike',
      'species': 'Lizard',
      'breed': 'Bearded Dragon',
      'age': '1 year',
      'image': 'assets/images/sale25-removebg-preview.png',
      'health': 'Healthy',
      'foundDate': '2023-09-12',
      'activities': ['Basking in heat', 'Eating vegetables', 'Exploring'],
      'description':
          'Spike is a calm and friendly bearded dragon who enjoys warm environments.',
      'adoptionStatus': 'Available',
    },
    {
      'id': '7',
      'name': 'Fluffy',
      'species': 'Guinea Pig',
      'breed': 'American Guinea Pig',
      'age': '8 months',
      'image': 'assets/images/sale30-removebg-preview.png',
      'health': 'Healthy',
      'foundDate': '2023-10-18',
      'activities': ['Eating hay', 'Playing with toys', 'Socializing'],
      'description':
          'Fluffy is a social and gentle guinea pig who loves company and fresh vegetables.',
      'adoptionStatus': 'Available',
    },
    {
      'id': '9',
      'name': 'Mittens',
      'species': 'Cat',
      'breed': 'Maine Coon',
      'age': '3 years',
      'image': 'assets/images/sale9-removebg-preview.png',
      'health': 'Healthy',
      'foundDate': '2023-04-15',
      'activities': ['Hunting toys', 'Climbing', 'Cuddling'],
      'description':
          'Mittens is a large and friendly Maine Coon who loves attention and play.',
      'adoptionStatus': 'Available',
    },
    {
      'id': '10',
      'name': 'Bella',
      'species': 'Dog',
      'breed': 'German Shepherd',
      'age': '1 year',
      'image': 'assets/images/sale12-removebg-preview.png',
      'health': 'Healthy',
      'foundDate': '2023-12-01',
      'activities': ['Protecting', 'Playing fetch', 'Learning commands'],
      'description':
          'Bella is a smart and protective German Shepherd who loves to work and play.',
      'adoptionStatus': 'Available',
    },
    {
      'id': '21',
      'name': 'Sunny',
      'species': 'Bird',
      'breed': 'Parrot',
      'age': '2 years',
      'gender': 'Male',
      'image': 'assets/images/sale11-removebg-preview.png',
      'health': 'Healthy',
      'vaccinated': true,
      'foundDate': '2024-01-15',
      'activities': ['Talking', 'Whistling', 'Playing with toys'],
      'description':
          'Sunny is a colorful parrot who loves to mimic sounds and interact with people.',
      'adoptionStatus': 'Available',
      'location': 'Abuja Shelter',
      'tags': ['talkative', 'playful', 'intelligent'],
    },
    {
      'id': '22',
      'name': 'Luna',
      'species': 'Bird',
      'breed': 'Canary',
      'age': '1 year',
      'gender': 'Female',
      'image': 'assets/images/sale12-removebg-preview.png',
      'health': 'Healthy',
      'vaccinated': false,
      'foundDate': '2024-02-10',
      'activities': ['Singing', 'Flying around', 'Perching'],
      'description':
          'Luna is a sweet canary with a beautiful singing voice, perfect for a calm home.',
      'adoptionStatus': 'Adopted',
      'location': 'Lagos Shelter',
      'tags': ['calm', 'musical', 'gentle'],
    },
    {
      'id': '23',
      'name': 'Sky',
      'species': 'Bird',
      'breed': 'Cockatiel',
      'age': '6 months',
      'gender': 'Male',
      'image': 'assets/images/sale13-removebg-preview.png',
      'health': 'Healthy',
      'vaccinated': true,
      'foundDate': '2024-03-01',
      'activities': ['Chirping', 'Flying short distances', 'Exploring'],
      'description': 'Sky is a young cockatiel full of energy and curiosity.',
      'adoptionStatus': 'Available',
      'location': 'Port Harcourt Shelter',
      'tags': ['curious', 'active', 'friendly'],
    },
    {
      'id': '31',
      'name': 'Cocoa',
      'species': 'Rabbit',
      'breed': 'American',
      'age': '8 months',
      'gender': 'Female',
      'image': 'assets/images/sale15-removebg-preview.png',
      'health': 'Healthy',
      'vaccinated': false,
      'foundDate': '2024-02-25',
      'activities': ['Nibbling', 'Exploring tunnels', 'Squeaking'],
      'description':
          'Cocoa is a gentle guinea pig who enjoys cuddling and small treats.',
      'adoptionStatus': 'Available',
      'location': 'Enugu Shelter',
      'tags': ['gentle', 'friendly', 'small'],
    },
    {
      'id': '32',
      'name': 'Oreo',
      'species': 'Rabbit',
      'breed': 'Abyssinian',
      'age': '1 year',
      'gender': 'Male',
      'image': 'assets/images/sale16-removebg-preview.png',
      'health': 'Healthy',
      'vaccinated': true,
      'foundDate': '2024-03-12',
      'activities': ['Running', 'Playing hide and seek', 'Squeaking loudly'],
      'description':
          'Oreo is playful and active, perfect for families with children.',
      'adoptionStatus': 'Available',
      'location': 'Lagos Shelter',
      'tags': ['playful', 'active', 'social'],
    },
    {
      'id': '33',
      'name': 'Hazel',
      'species': 'Guinea Pig',
      'breed': 'Peruvian',
      'age': '2 years',
      'gender': 'Female',
      'image': 'assets/images/sale18-removebg-preview.png',
      'health': 'Minor skin issues',
      'vaccinated': true,
      'foundDate': '2023-12-20',
      'activities': ['Resting', 'Eating veggies', 'Cuddling'],
      'description': 'Hazel is calm and loving, ideal for a quiet household.',
      'adoptionStatus': 'Pending',
      'location': 'Abuja Shelter',
      'tags': ['calm', 'loving', 'quiet'],
    },
    {
      'id': '41',
      'name': 'Spike',
      'species': 'Lizard',
      'breed': 'Bearded Dragon',
      'age': '3 years',
      'gender': 'Male',
      'image': 'assets/images/sale33-removebg-preview.png',
      'health': 'Healthy',
      'vaccinated': false,
      'foundDate': '2024-01-30',
      'activities': ['Basking in the sun', 'Eating insects', 'Exploring rocks'],
      'description':
          'Spike is a calm bearded dragon that enjoys warmth and easy handling.',
      'adoptionStatus': 'Available',
      'location': 'Kano Shelter',
      'tags': ['exotic', 'calm', 'unique'],
    },
    {
      'id': '42',
      'name': 'Emerald',
      'species': 'Lizard',
      'breed': 'Green Iguana',
      'age': '2 years',
      'gender': 'Female',
      'image': 'assets/images/sale34-removebg-preview.png',
      'health': 'Healthy',
      'vaccinated': true,
      'foundDate': '2024-02-18',
      'activities': ['Climbing', 'Sunbathing', 'Eating greens'],
      'description': 'Emerald is a stunning iguana with vibrant green scales.',
      'adoptionStatus': 'Available',
      'location': 'Lagos Shelter',
      'tags': ['climber', 'exotic', 'green'],
    },
    {
      'id': '51',
      'name': 'Peanut',
      'species': 'Hamster',
      'breed': 'Syrian',
      'age': '6 months',
      'gender': 'Male',
      'image': 'assets/images/sale27-removebg-preview.png',
      'health': 'Healthy',
      'vaccinated': false,
      'foundDate': '2024-02-11',
      'activities': ['Running on wheel', 'Nibbling food', 'Hiding in bedding'],
      'description': 'Peanut is energetic and curious, always on the move.',
      'adoptionStatus': 'Available',
      'location': 'Abuja Shelter',
      'tags': ['energetic', 'curious', 'tiny'],
    },
    {
      'id': '52',
      'name': 'Nibbles',
      'species': 'Hamster',
      'breed': 'Roborovski',
      'age': '1 year',
      'gender': 'Female',
      'image': 'assets/images/sale29-removebg-preview.png',
      'health': 'Healthy',
      'vaccinated': true,
      'foundDate': '2024-03-02',
      'activities': ['Digging tunnels', 'Running fast', 'Eating seeds'],
      'description':
          'Nibbles is small and very fast, perfect for active owners.',
      'adoptionStatus': 'Pending',
      'location': 'Lagos Shelter',
      'tags': ['fast', 'playful', 'tiny'],
    },
    {
      'id': '53',
      'name': 'Muffin',
      'species': 'Hamster',
      'breed': 'Chinese',
      'age': '1.5 years',
      'gender': 'Male',
      'image': 'assets/images/sale26-removebg-preview.png',
      'health': 'Minor dental issues',
      'vaccinated': true,
      'foundDate': '2023-11-22',
      'activities': ['Climbing', 'Exploring tubes', 'Resting'],
      'description':
          'Muffin is calm and likes to explore slowly, good for beginners.',
      'adoptionStatus': 'Adopted',
      'location': 'Port Harcourt Shelter',
      'tags': ['calm', 'gentle', 'explorer'],
    },
    {
      'id': '61',
      'name': 'Bubbles',
      'species': 'Fish',
      'breed': 'Goldfish',
      'age': '1 year',
      'gender': 'Female',
      'image': 'assets/images/sale22-removebg-preview.png',
      'health': 'Healthy',
      'vaccinated': false,
      'foundDate': '2024-01-28',
      'activities': ['Swimming around', 'Chasing bubbles', 'Eating flakes'],
      'description':
          'Bubbles is a cheerful goldfish that brings life to any aquarium.',
      'adoptionStatus': 'Available',
      'location': 'Lagos Shelter',
      'tags': ['colorful', 'calm', 'aquatic'],
    },
    {
      'id': '62',
      'name': 'Finn',
      'species': 'Fish',
      'breed': 'Betta',
      'age': '8 months',
      'gender': 'Male',
      'image': 'assets/images/sale23-removebg-preview.png',
      'health': 'Healthy',
      'vaccinated': false,
      'foundDate': '2024-02-16',
      'activities': ['Swimming gracefully', 'Flaring fins', 'Exploring plants'],
      'description':
          'Finn is a vibrant Betta fish known for his striking colors and lively behavior.',
      'adoptionStatus': 'Available',
      'location': 'Abuja Shelter',
      'tags': ['vibrant', 'graceful', 'ornamental'],
    },
    {
      'id': '63',
      'name': 'Coral',
      'species': 'Fish',
      'breed': 'Guppy',
      'age': '6 months',
      'gender': 'Female',
      'image': 'assets/images/sale24-removebg-preview.png',
      'health': 'Healthy',
      'vaccinated': false,
      'foundDate': '2024-03-03',
      'activities': ['Swimming in groups', 'Exploring tank', 'Eating flakes'],
      'description':
          'Coral is a lively guppy who enjoys swimming with other fish.',
      'adoptionStatus': 'Pending',
      'location': 'Port Harcourt Shelter',
      'tags': ['lively', 'social', 'tiny'],
    },
  ];

  List<Map<String, dynamic>> get _filteredPets {
    if (_selectedCategory == 'All') {
      return _shelterPets;
    }
    return _shelterPets.where((pet) {
      switch (_selectedCategory) {
        case 'Dogs':
          return pet['species'] == 'Dog';
        case 'Cats':
          return pet['species'] == 'Cat';
        case 'Small Animals':
          return ['Hamster', 'Guinea Pig'].contains(pet['species']);
        case 'Reptiles':
          return pet['species'] == 'Lizard';
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Pets'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Iconsax.search_normal),
            onPressed: () {
              // TODO: Implement search functionality
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Filter
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category;

                return Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    selectedColor: AppTheme.primaryColor.withOpacity(0.2),
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

          // Pets Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _filteredPets.length,
              itemBuilder: (context, index) {
                final pet = _filteredPets[index];
                return _buildPetCard(pet);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPetCard(Map<String, dynamic> pet) {
    return GestureDetector(
      onTap: () => _showPetDetails(pet),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pet Image
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  color: AppTheme.primaryColor.withOpacity(0.1),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Image.asset(
                    pet['image'],
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Icon(
                          _getPetIcon(pet['species']),
                          size: 60,
                          color: AppTheme.primaryColor,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // Pet Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top section with name and breed
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pet['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${pet['breed']} • ${pet['age']}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 11,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),

                    // Status badge at bottom
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: pet['adoptionStatus'] == 'Available'
                            ? Colors.green.withOpacity(0.1)
                            : pet['adoptionStatus'] == 'Adopted'
                            ? Colors.blue.withOpacity(0.1)
                            : Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        pet['adoptionStatus'],
                        style: TextStyle(
                          color: pet['adoptionStatus'] == 'Available'
                              ? Colors.green
                              : pet['adoptionStatus'] == 'Adopted'
                              ? Colors.blue
                              : Colors.orange,
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getPetIcon(String species) {
    switch (species) {
      case 'Dog':
        return Iconsax.pet;
      case 'Cat':
        return Iconsax.pet;
      case 'Hamster':
      case 'Guinea Pig':
        return Iconsax.pet;
      case 'Lizard':
        return Iconsax.pet;
      default:
        return Iconsax.pet;
    }
  }

  void _showPetDetails(Map<String, dynamic> pet) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Pet Image
                Center(
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: AppTheme.primaryColor.withOpacity(0.1),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        pet['image'],
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Icon(
                              _getPetIcon(pet['species']),
                              size: 80,
                              color: AppTheme.primaryColor,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Pet Name and Basic Info
                Center(
                  child: Column(
                    children: [
                      Text(
                        pet['name'],
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${pet['breed']} • ${pet['age']}',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Details
                _buildDetailRow('Health Status', pet['health'], Iconsax.health),
                _buildDetailRow(
                  'Found Date',
                  pet['foundDate'],
                  Iconsax.calendar,
                ),
                _buildDetailRow('Species', pet['species'], Iconsax.pet),
                _buildDetailRow(
                  'Adoption Status',
                  pet['adoptionStatus'],
                  Iconsax.heart,
                ),

                const SizedBox(height: 20),

                // Description
                const Text(
                  'About',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  pet['description'],
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 20),

                // Activities
                const Text(
                  'Activities & Interests',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: (pet['activities'] as List<String>).map((activity) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        activity,
                        style: const TextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 30),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(color: AppTheme.primaryColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Close',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Implement adoption request
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Adoption request for ${pet['name']} sent!',
                              ),
                              backgroundColor: AppTheme.primaryColor,
                            ),
                          );
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Adopt Me!',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryColor, size: 20),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }
}
