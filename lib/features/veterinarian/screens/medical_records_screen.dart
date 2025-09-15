import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pawfect_care/core/theme/app_theme.dart';

class MedicalRecordsScreen extends ConsumerStatefulWidget {
  const MedicalRecordsScreen({super.key});

  @override
  ConsumerState<MedicalRecordsScreen> createState() =>
      _MedicalRecordsScreenState();
}

class _MedicalRecordsScreenState extends ConsumerState<MedicalRecordsScreen> {
  String _selectedPetId = '';

  @override
  void initState() {
    super.initState();
    // Get petId from URL parameters if available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final uri = Uri.parse(GoRouterState.of(context).uri.toString());
      final petId = uri.queryParameters['petId'];
      if (petId != null && petId.isNotEmpty) {
        setState(() {
          _selectedPetId = petId;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical Records'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_2),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/vet-dashboard');
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.add),
            onPressed: () => _showAddRecordDialog(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pet Selector
            _buildPetSelector(),
            const SizedBox(height: 24),

            // Medical Records List
            if (_selectedPetId.isNotEmpty) ...[
              _buildSectionTitle('Medical History', Iconsax.document_text),
              const SizedBox(height: 12),
              _buildMedicalRecordsList(),
            ] else ...[
              _buildEmptyState(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPetSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Pet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _selectedPetId.isEmpty ? null : _selectedPetId,
            decoration: InputDecoration(
              hintText: 'Choose a pet',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              prefixIcon: const Icon(Iconsax.pet),
            ),
            items: [
              const DropdownMenuItem(
                value: 'pet_1',
                child: Text('Buddy - Golden Retriever'),
              ),
              const DropdownMenuItem(
                value: 'pet_2',
                child: Text('Whiskers - Persian Cat'),
              ),
              const DropdownMenuItem(
                value: 'pet_3',
                child: Text('Max - Labrador'),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _selectedPetId = value ?? '';
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primaryColor, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.document_text, size: 100, color: Colors.grey[400]),
          const SizedBox(height: 24),
          Text(
            'Select a Pet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose a pet to view their medical records',
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicalRecordsList() {
    // Mock medical records data
    final records = [
      {
        'id': '1',
        'type': 'vaccination',
        'title': 'Rabies Vaccine',
        'date': DateTime.now().subtract(const Duration(days: 30)),
        'nextDue': DateTime.now().add(const Duration(days: 335)),
        'notes': 'Annual rabies vaccination administered',
        'prescription': 'No additional medication needed',
      },
      {
        'id': '2',
        'type': 'checkup',
        'title': 'Annual Health Check',
        'date': DateTime.now().subtract(const Duration(days: 60)),
        'nextDue': DateTime.now().add(const Duration(days: 305)),
        'notes': 'Overall health is excellent. Weight is optimal.',
        'prescription': 'Continue current diet and exercise routine',
      },
      {
        'id': '3',
        'type': 'medication',
        'title': 'Deworming Treatment',
        'date': DateTime.now().subtract(const Duration(days: 90)),
        'nextDue': DateTime.now().add(const Duration(days: 275)),
        'notes': 'Administered deworming medication',
        'prescription': 'Deworming tablet - 1 tablet monthly',
      },
    ];

    return Column(
      children: records.map((record) => _buildRecordCard(record)).toList(),
    );
  }

  Widget _buildRecordCard(Map<String, dynamic> record) {
    final type = record['type'] as String;
    final date = record['date'] as DateTime;
    final nextDue = record['nextDue'] as DateTime;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        record['title'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getTypeColor(type).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _getTypeText(type),
                          style: TextStyle(
                            color: _getTypeColor(type),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  _formatDate(date),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Next Due Date
            if (nextDue.isAfter(DateTime.now())) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Iconsax.clock, color: Colors.blue[600], size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'Next due: ${_formatDate(nextDue)}',
                      style: TextStyle(
                        color: Colors.blue[800],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Notes
            if (record['notes'] != null) ...[
              _buildInfoRow('Notes', record['notes'], Iconsax.document_text),
              const SizedBox(height: 8),
            ],

            // Prescription
            if (record['prescription'] != null) ...[
              _buildInfoRow(
                'Prescription',
                record['prescription'],
                Iconsax.document_text,
              ),
            ],

            // Actions
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _editRecord(record),
                    icon: const Icon(Iconsax.edit, size: 16),
                    label: const Text('Edit'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryColor,
                      side: BorderSide(color: AppTheme.primaryColor),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _addNewRecord(),
                    icon: const Icon(Iconsax.add, size: 16),
                    label: const Text('Add New'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(fontSize: 14, color: Colors.grey[800]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'vaccination':
        return Colors.green;
      case 'checkup':
        return Colors.blue;
      case 'medication':
        return Colors.orange;
      case 'surgery':
        return Colors.red;
      case 'allergy':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _getTypeText(String type) {
    switch (type) {
      case 'vaccination':
        return 'Vaccination';
      case 'checkup':
        return 'Health Check';
      case 'medication':
        return 'Medication';
      case 'surgery':
        return 'Surgery';
      case 'allergy':
        return 'Allergy';
      default:
        return type.toUpperCase();
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showAddRecordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Medical Record'),
        content: const Text(
          'This feature allows veterinarians to add new medical records, prescriptions, and treatment notes.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _addNewRecord();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Add Record'),
          ),
        ],
      ),
    );
  }

  void _addNewRecord() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Add new medical record functionality would be implemented here',
        ),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _editRecord(Map<String, dynamic> record) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Edit ${record['title']} record functionality would be implemented here',
        ),
        backgroundColor: Colors.orange,
      ),
    );
  }
}
