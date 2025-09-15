import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pawfect_care/core/theme/app_theme.dart';
import 'package:pawfect_care/core/services/user_service.dart';
import 'package:pawfect_care/core/services/auth_service.dart';

class VetDashboard extends StatefulWidget {
  const VetDashboard({super.key});

  @override
  State<VetDashboard> createState() => _VetDashboardState();
}

class _VetDashboardState extends State<VetDashboard> {
  int _currentIndex = 0;
  final _userService = UserService();
  Map<String, dynamic>? _userData;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<Map<String, dynamic>> _filteredPatients = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _searchController.addListener(_onSearchChanged);
    _filteredPatients = _getMockPatients();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
      _filteredPatients = _getMockPatients().where((patient) {
        final petName = (patient['petName'] ?? '').toLowerCase();
        final ownerName = (patient['ownerName'] ?? '').toLowerCase();
        final species = (patient['species'] ?? '').toLowerCase();
        final breed = (patient['breed'] ?? '').toLowerCase();
        return petName.contains(_searchQuery) ||
               ownerName.contains(_searchQuery) ||
               species.contains(_searchQuery) ||
               breed.contains(_searchQuery);
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
      return _userData!['name'] ?? 'Dr. User';
    }
    return 'Dr. User';
  }

  String _getUserEmail() {
    if (_userData != null) {
      return _userData!['email'] ?? 'dr.user@vet.com';
    }
    return 'dr.user@vet.com';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Veterinarian Dashboard'),
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
          _buildAppointmentsTab(),
          _buildPatientsTab(),
          _buildHealthRecordsTab(),
          _buildBlogTab(),
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
          BottomNavigationBarItem(icon: Icon(Iconsax.calendar), label: 'Appointments'),
          BottomNavigationBarItem(icon: Icon(Iconsax.pet), label: 'Patients'),
          BottomNavigationBarItem(icon: Icon(Iconsax.health), label: 'Health Records'),
          BottomNavigationBarItem(icon: Icon(Iconsax.document_text), label: 'Blog & Feed'),
          BottomNavigationBarItem(icon: Icon(Iconsax.profile_circle), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildAppointmentsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Today's Schedule Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Today\'s Schedule', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ElevatedButton.icon(
                onPressed: () => _showScheduleAppointmentDialog(),
                icon: const Icon(Iconsax.add),
                label: const Text('Schedule'),
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryColor, foregroundColor: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Appointments List
          _buildAppointmentsList(),
        ],
      ),
    );
  }

  Widget _buildAppointmentsList() {
    final appointments = [
      {
        'time': '09:00 AM',
        'pet': 'Max',
        'owner': 'John Doe',
        'reason': 'Annual Checkup',
        'status': 'confirmed',
        'petId': '1',
        'healthNotes': 'Last visit: Healthy, needs vaccination',
        'breed': 'Golden Retriever',
        'color': Colors.amber,
      },
      {
        'time': '10:30 AM',
        'pet': 'Bella',
        'owner': 'Jane Smith',
        'reason': 'Vaccination',
        'status': 'confirmed',
        'petId': '2',
        'healthNotes': 'First time visit, needs full examination',
        'breed': 'Siberian Husky',
        'color': Colors.blue,
      },
      {
        'time': '02:00 PM',
        'pet': 'Charlie',
        'owner': 'Mike Johnson',
        'reason': 'Emergency - Injury',
        'status': 'urgent',
        'petId': '3',
        'healthNotes': 'Emergency case - leg injury from accident',
        'breed': 'Labrador',
        'color': Colors.red,
      },
      {
        'time': '03:30 PM',
        'pet': 'Luna',
        'owner': 'Sarah Johnson',
        'reason': 'Follow-up Check',
        'status': 'confirmed',
        'petId': '4',
        'healthNotes': 'Post-surgery follow-up, healing well',
        'breed': 'Persian Cat',
        'color': Colors.purple,
      },
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: (appointment['status'] == 'urgent') 
                ? Border.all(color: Colors.red, width: 2) 
                : Border.all(color: (appointment['color'] as Color).withOpacity(0.2), width: 1),
            boxShadow: [
              BoxShadow(
                color: (appointment['color'] as Color).withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Time and Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: (appointment['color'] as Color).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.schedule,
                            color: appointment['color'] as Color,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          appointment['time'] as String,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: (appointment['status'] == 'confirmed') 
                            ? Colors.green.withOpacity(0.1) 
                            : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: (appointment['status'] == 'confirmed') ? Colors.green : Colors.red,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            (appointment['status'] == 'confirmed') ? Icons.check_circle : Icons.warning,
                            size: 14,
                            color: (appointment['status'] == 'confirmed') ? Colors.green : Colors.red,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            (appointment['status'] as String).toUpperCase(),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: (appointment['status'] == 'confirmed') ? Colors.green : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Pet Information with Emoji
                Row(
                  children: [
                    Text(
                      _getPetEmoji(appointment['breed'] as String),
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${appointment['pet']} (${appointment['breed']})',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.person, size: 14, color: Colors.grey[500]),
                              const SizedBox(width: 4),
                              Text(
                                'Owner: ${appointment['owner']}',
                                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Icon(Icons.medical_services, size: 14, color: Colors.grey[500]),
                              const SizedBox(width: 4),
                              Text(
                                'Reason: ${appointment['reason']}',
                                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Health Notes with Cute Styling
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.note_alt, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Health Notes: ${appointment['healthNotes']}',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600], fontStyle: FontStyle.italic),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                
                // Action Buttons with Cute Styling
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppTheme.primaryColor, AppTheme.primaryColor.withOpacity(0.8)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ElevatedButton(
                          onPressed: () => _viewPetHealthInfo(appointment['petId'] as String),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('View Health Info', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green.withOpacity(0.3)),
                        ),
                        child: OutlinedButton(
                          onPressed: () => _addMedicalNotes(appointment),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.green,
                            side: BorderSide.none,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Add Notes', style: TextStyle(fontWeight: FontWeight.w600)),
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

  Widget _buildPatientsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search and Filter
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search patients...',
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
              ),
              const SizedBox(width: 12),
              IconButton(
                onPressed: () => _showFilterDialog(),
                icon: const Icon(Iconsax.filter),
                style: IconButton.styleFrom(backgroundColor: AppTheme.primaryColor, foregroundColor: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Patients List
          Text(
            _searchQuery.isNotEmpty 
                ? 'Search Results (${_filteredPatients.length})' 
                : 'All Patients',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)
          ),
          const SizedBox(height: 16),
          _buildPatientsList(),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getMockPatients() {
    return [
      {
        'id': '1',
        'petName': 'Max',
        'breed': 'Golden Retriever',
        'species': 'Dog',
        'age': '3 years',
        'ownerName': 'John Doe',
        'lastVisit': '2024-01-10',
        'healthStatus': 'Healthy',
        'image': 'assets/images/pet1.jpg',
        'medicalHistory': ['Vaccinated', 'Spayed', 'Regular checkups'],
        'color': Colors.amber,
      },
      {
        'id': '2',
        'petName': 'Bella',
        'breed': 'Siberian Husky',
        'species': 'Dog',
        'age': '2 years',
        'ownerName': 'Jane Smith',
        'lastVisit': '2024-01-08',
        'healthStatus': 'Under Treatment',
        'image': 'assets/images/pet2.jpg',
        'medicalHistory': ['Vaccinated', 'Skin condition treatment'],
        'color': Colors.blue,
      },
      {
        'id': '3',
        'petName': 'Luna',
        'breed': 'Persian Cat',
        'species': 'Cat',
        'age': '1 year',
        'ownerName': 'Sarah Johnson',
        'lastVisit': '2024-01-12',
        'healthStatus': 'Healthy',
        'image': 'assets/images/pet3.jpg',
        'medicalHistory': ['Vaccinated', 'Spayed'],
        'color': Colors.purple,
      },
      {
        'id': '4',
        'petName': 'Charlie',
        'breed': 'Labrador',
        'species': 'Dog',
        'age': '4 years',
        'ownerName': 'Mike Wilson',
        'lastVisit': '2024-01-09',
        'healthStatus': 'Recovery',
        'image': 'assets/images/pet4.jpg',
        'medicalHistory': ['Vaccinated', 'Surgery recovery'],
        'color': Colors.green,
      },
      {
        'id': '5',
        'petName': 'Mittens',
        'breed': 'Maine Coon',
        'species': 'Cat',
        'age': '2 years',
        'ownerName': 'Emily Davis',
        'lastVisit': '2024-01-11',
        'healthStatus': 'Healthy',
        'image': 'assets/images/pet5.jpg',
        'medicalHistory': ['Vaccinated', 'Neutered'],
        'color': Colors.orange,
      },
    ];
  }

  Widget _buildPatientsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _filteredPatients.length,
      itemBuilder: (context, index) {
        final patient = _filteredPatients[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: (patient['color'] as Color).withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: (patient['color'] as Color).withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Cute Pet Image with Decorative Border
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: (patient['color'] as Color).withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      patient['image'] as String,
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: (patient['color'] as Color).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.pets,
                          color: patient['color'] as Color,
                          size: 35,
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
                      // Pet Name with Cute Emoji
                      Row(
                        children: [
                          Text(
                            patient['petName'] as String,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _getPetEmoji(patient['breed'] as String),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Breed and Age with Color
                      Text(
                        '${patient['breed']} • ${patient['age']}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      // Owner with Icon
                      Row(
                        children: [
                          Icon(Icons.person, size: 14, color: Colors.grey[500]),
                          const SizedBox(width: 4),
                          Text(
                            patient['ownerName'] as String,
                            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      // Last Visit with Calendar Icon
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 14, color: Colors.grey[500]),
                          const SizedBox(width: 4),
                          Text(
                            'Last visit: ${patient['lastVisit']}',
                            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Health Status Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getHealthStatusColor(patient['healthStatus'] as String).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _getHealthStatusColor(patient['healthStatus'] as String).withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getHealthStatusIcon(patient['healthStatus'] as String),
                              size: 12,
                              color: _getHealthStatusColor(patient['healthStatus'] as String),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              patient['healthStatus'] as String,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: _getHealthStatusColor(patient['healthStatus'] as String),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Action Buttons with Cute Styling
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(Iconsax.eye, size: 20),
                        onPressed: () => _viewPetHealthInfo(patient['id'] as String),
                        tooltip: 'View Health Info',
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(Iconsax.document_text, size: 20),
                        onPressed: () => _viewMedicalRecords(patient['id'] as String),
                        tooltip: 'Medical Records',
                        color: Colors.green,
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

  Widget _buildHealthRecordsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick Stats
          Row(
            children: [
              Expanded(child: _buildStatCard('Total Patients', '24', Iconsax.pet, Colors.blue)),
              const SizedBox(width: 16),
              Expanded(child: _buildStatCard('This Week', '8', Iconsax.calendar, Colors.green)),
            ],
          ),
          const SizedBox(height: 24),
          
          // Recent Records
          const Text('Recent Medical Records', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          _buildMedicalRecordsList(),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
          Text(title, style: TextStyle(fontSize: 14, color: color)),
        ],
      ),
    );
  }

  Widget _buildMedicalRecordsList() {
    final records = [
      {'date': '2024-01-10', 'pet': 'Max', 'type': 'Vaccination', 'description': 'Annual rabies vaccination administered', 'vet': _getUserDisplayName()},
      {'date': '2024-01-08', 'pet': 'Bella', 'type': 'Treatment', 'description': 'Skin condition treatment - prescribed medication', 'vet': _getUserDisplayName()},
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: records.length,
      itemBuilder: (context, index) {
        final record = records[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 4, offset: const Offset(0, 2))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(record['type'] as String, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  Text(record['date'] as String, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                ],
              ),
              const SizedBox(height: 4),
              Text('Pet: ${record['pet']}', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
              Text(record['description'] as String, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
              Text('Vet: ${record['vet']}', style: TextStyle(fontSize: 12, color: Colors.grey[500])),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBlogTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Professional Resources', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          
          // Quick Access Cards
          Row(
            children: [
              Expanded(
                child: _buildQuickAccessCard('Blog Articles', Iconsax.document_text, Colors.blue, () => context.go('/vet-blog')),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildQuickAccessCard('Animal Feed', Iconsax.video, Colors.green, () => context.go('/vet-animal-feed')),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Professional Tools
          const Text('Professional Tools', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          _buildProfessionalTools(),
        ],
      ),
    );
  }

  Widget _buildQuickAccessCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 40),
            const SizedBox(height: 12),
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildProfessionalTools() {
    final tools = [
      {'icon': Iconsax.calculator, 'title': 'Dosage Calculator', 'color': Colors.purple},
      {'icon': Iconsax.document_text, 'title': 'Medical Templates', 'color': Colors.orange},
      {'icon': Iconsax.chart, 'title': 'Health Analytics', 'color': Colors.teal},
      {'icon': Iconsax.message, 'title': 'Client Communication', 'color': Colors.indigo},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 1.2),
      itemCount: tools.length,
      itemBuilder: (context, index) {
        final tool = tools[index];
        return GestureDetector(
          onTap: () => _showToolDialog(tool['title'] as String),
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
                  decoration: BoxDecoration(color: (tool['color'] as Color).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                  child: Icon(tool['icon'] as IconData, color: tool['color'] as Color, size: 24),
                ),
                const SizedBox(height: 12),
                Text(tool['title'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
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
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: Column(
              children: [
                const CircleAvatar(radius: 40, backgroundColor: AppTheme.primaryColor, child: Icon(Icons.person, size: 40, color: Colors.white)),
                const SizedBox(height: 16),
                Text(_getUserDisplayName(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Veterinarian', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                Text(_getUserEmail(), style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildProfileStat('Patients', '24'),
                    _buildProfileStat('Experience', '5 years'),
                    _buildProfileStat('Rating', '4.9'),
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
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
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

  // Dialog Methods
  void _showToolDialog(String toolName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(toolName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (toolName == 'Dosage Calculator') ...[
              const Text('Calculate medication dosages based on pet weight and condition.'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showDosageCalculator();
                },
                child: const Text('Open Calculator'),
              ),
            ] else if (toolName == 'Medical Templates') ...[
              const Text('Access pre-made medical report templates.'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showMedicalTemplates();
                },
                child: const Text('View Templates'),
              ),
            ] else if (toolName == 'Health Analytics') ...[
              const Text('View health trends and analytics for your patients.'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showHealthAnalytics();
                },
                child: const Text('View Analytics'),
              ),
            ] else if (toolName == 'Client Communication') ...[
              const Text('Send messages and updates to pet owners.'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showClientCommunication();
                },
                child: const Text('Open Messages'),
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

  void _showDosageCalculator() {
    final weightController = TextEditingController();
    final dosageController = TextEditingController();
    String selectedMedication = 'Amoxicillin';
    double calculatedDosage = 0.0;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Dosage Calculator'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: weightController,
                  decoration: const InputDecoration(
                    labelText: 'Pet Weight (kg)',
                    border: OutlineInputBorder(),
                    hintText: 'Enter weight in kilograms',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    if (value.isNotEmpty && dosageController.text.isNotEmpty) {
                      final weight = double.tryParse(value) ?? 0;
                      final dosagePerKg = double.tryParse(dosageController.text) ?? 0;
                      setState(() {
                        calculatedDosage = weight * dosagePerKg;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedMedication,
                  decoration: const InputDecoration(
                    labelText: 'Medication',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    'Amoxicillin',
                    'Cephalexin',
                    'Metronidazole',
                    'Prednisolone',
                    'Furosemide',
                    'Carprofen',
                    'Tramadol',
                    'Gabapentin'
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedMedication = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: dosageController,
                  decoration: const InputDecoration(
                    labelText: 'Dosage (mg/kg)',
                    border: OutlineInputBorder(),
                    hintText: 'Enter dosage per kg',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    if (value.isNotEmpty && weightController.text.isNotEmpty) {
                      final weight = double.tryParse(weightController.text) ?? 0;
                      final dosagePerKg = double.tryParse(value) ?? 0;
                      setState(() {
                        calculatedDosage = weight * dosagePerKg;
                      });
                    }
                  },
                ),
                const SizedBox(height: 20),
                if (calculatedDosage > 0) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Calculated Dosage',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${calculatedDosage.toStringAsFixed(2)} mg',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'For ${weightController.text}kg pet',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ],
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
                if (weightController.text.isNotEmpty && dosageController.text.isNotEmpty) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Dosage calculated: ${calculatedDosage.toStringAsFixed(2)}mg of $selectedMedication'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter weight and dosage'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Calculate'),
            ),
          ],
        ),
      ),
    );
  }

  void _showMedicalTemplates() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Medical Templates'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Iconsax.document_text),
              title: const Text('Vaccination Record'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Vaccination template opened')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Iconsax.health),
              title: const Text('Health Check Report'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Health check template opened')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Iconsax.document),
              title: const Text('Surgery Report'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Surgery template opened')),
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

  void _showHealthAnalytics() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Health Analytics'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('📊 Patient Health Trends'),
            SizedBox(height: 8),
            Text('📈 Vaccination Coverage: 95%'),
            Text('🏥 Common Conditions: Dental, Skin'),
            Text('📅 Average Visit Frequency: 2.3/year'),
            Text('💊 Most Prescribed: Antibiotics'),
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

  void _showClientCommunication() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Client Communication'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Iconsax.message),
              title: const Text('Send Appointment Reminder'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Appointment reminder sent')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Iconsax.notification),
              title: const Text('Health Update'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Health update sent')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Iconsax.document_text),
              title: const Text('Lab Results'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Lab results shared')),
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
  void _showScheduleAppointmentDialog() {
    final petController = TextEditingController();
    final ownerController = TextEditingController();
    final dateController = TextEditingController();
    final timeController = TextEditingController();
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Schedule New Appointment'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: petController,
                decoration: const InputDecoration(
                  labelText: 'Pet Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: ownerController,
                decoration: const InputDecoration(
                  labelText: 'Owner Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: dateController,
                decoration: const InputDecoration(
                  labelText: 'Date (YYYY-MM-DD)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: timeController,
                decoration: const InputDecoration(
                  labelText: 'Time (HH:MM)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: reasonController,
                decoration: const InputDecoration(
                  labelText: 'Reason for Visit',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
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
              if (petController.text.isNotEmpty && ownerController.text.isNotEmpty) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Appointment scheduled for ${petController.text} with ${ownerController.text}'),
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
            child: const Text('Schedule'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    String selectedFilter = 'All';
    String selectedStatus = 'All';
    String selectedDate = 'All';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Filter Patients'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedFilter,
                decoration: const InputDecoration(
                  labelText: 'Pet Type',
                  border: OutlineInputBorder(),
                ),
                items: ['All', 'Dog', 'Cat', 'Bird', 'Other'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedFilter = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedStatus,
                decoration: const InputDecoration(
                  labelText: 'Health Status',
                  border: OutlineInputBorder(),
                ),
                items: ['All', 'Healthy', 'Sick', 'Recovering', 'Critical'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedStatus = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedDate,
                decoration: const InputDecoration(
                  labelText: 'Last Visit',
                  border: OutlineInputBorder(),
                ),
                items: ['All', 'Today', 'This Week', 'This Month', 'Overdue'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedDate = newValue!;
                  });
                },
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
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Filtered by: $selectedFilter, $selectedStatus, $selectedDate'),
                    backgroundColor: Colors.blue,
                  ),
                );
              },
              child: const Text('Apply Filter'),
            ),
          ],
        ),
      ),
    );
  }

  void _viewPetHealthInfo(String petId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pet Health Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Health Status: Healthy'),
            const Text('Last Vaccination: 2024-01-10'),
            const Text('Weight: 25.5 kg'),
            const Text('Temperature: 38.2°C'),
            const Text('Heart Rate: 85 bpm'),
            const Text('Notes: Regular checkup needed'),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
      ),
    );
  }

  void _addMedicalNotes(Map<String, dynamic> appointment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Medical Notes'),
        content: const TextField(
          decoration: InputDecoration(hintText: 'Enter medical notes...'),
          maxLines: 3,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Save')),
        ],
      ),
    );
  }

  void _viewMedicalRecords(String petId) {
    // Navigate to medical records screen with the specific pet ID
    context.go('/vet/medical-records?petId=$petId');
  }

  // Helper methods for cute styling
  String _getPetEmoji(String breed) {
    if (breed.toLowerCase().contains('dog') || breed.toLowerCase().contains('retriever') || breed.toLowerCase().contains('labrador') || breed.toLowerCase().contains('husky')) {
      return '🐕';
    } else if (breed.toLowerCase().contains('cat') || breed.toLowerCase().contains('persian') || breed.toLowerCase().contains('maine coon')) {
      return '🐱';
    } else if (breed.toLowerCase().contains('hamster')) {
      return '🐹';
    } else if (breed.toLowerCase().contains('lizard')) {
      return '🦎';
    } else if (breed.toLowerCase().contains('guinea pig')) {
      return '🐹';
    } else {
      return '🐾';
    }
  }

  Color _getHealthStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'healthy':
        return Colors.green;
      case 'under treatment':
        return Colors.orange;
      case 'recovery':
        return Colors.blue;
      case 'urgent':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getHealthStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'healthy':
        return Icons.check_circle;
      case 'under treatment':
        return Icons.medical_services;
      case 'recovery':
        return Icons.healing;
      case 'urgent':
        return Icons.warning;
      default:
        return Icons.help;
    }
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