import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pawfect_care/core/theme/app_theme.dart';
import 'package:pawfect_care/features/pets/models/pet_model.dart';
import 'package:pawfect_care/features/pets/providers/pet_provider.dart';

class AddPetScreen extends ConsumerStatefulWidget {
  const AddPetScreen({super.key});

  @override
  ConsumerState<AddPetScreen> createState() => _AddPetScreenState();
}

class _AddPetScreenState extends ConsumerState<AddPetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _breedController = TextEditingController();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _colorController = TextEditingController();
  
  String _selectedSpecies = 'Dog';
  String _selectedGender = 'Male';
  DateTime? _selectedBirthDate;
  bool _isLoading = false;

  final List<String> _speciesList = [
    'Dog', 'Cat', 'Bird', 'Fish', 'Rabbit', 'Hamster', 'Other'
  ];

  final List<String> _genderList = ['Male', 'Female'];

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Pet'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_2),
          onPressed: () => context.pop(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.primaryColor.withValues(alpha: 0.1),
                            AppTheme.primaryColor.withValues(alpha: 0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Iconsax.pet,
                            size: 40,
                            color: AppTheme.primaryColor,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Add New Pet',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Tell us about your furry friend',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Basic Information
                    _buildSectionTitle('Basic Information', Iconsax.user),
                    const SizedBox(height: 16),
                    _buildTextFormField(
                      controller: _nameController,
                      label: 'Pet Name',
                      hint: 'Enter your pet\'s name',
                      prefixIcon: Iconsax.pet,
                      validator: (value) => value?.isEmpty == true ? 'Please enter pet name' : null,
                    ),
                    const SizedBox(height: 16),
                    _buildDropdown(
                      label: 'Species',
                      value: _selectedSpecies,
                      items: _speciesList,
                      onChanged: (value) => setState(() => _selectedSpecies = value!),
                    ),
                    const SizedBox(height: 16),
                    _buildTextFormField(
                      controller: _breedController,
                      label: 'Breed',
                      hint: 'Enter breed (e.g., Golden Retriever)',
                      prefixIcon: Iconsax.tag,
                    ),
                    const SizedBox(height: 16),
                    _buildDropdown(
                      label: 'Gender',
                      value: _selectedGender,
                      items: _genderList,
                      onChanged: (value) => setState(() => _selectedGender = value!),
                    ),
                    const SizedBox(height: 16),
                    _buildTextFormField(
                      controller: _ageController,
                      label: 'Age (months)',
                      hint: 'Enter age in months',
                      prefixIcon: Iconsax.calendar,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value?.isEmpty == true) return 'Please enter age';
                        if (int.tryParse(value!) == null) return 'Please enter valid number';
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Additional Details
                    _buildSectionTitle('Additional Details', Iconsax.info_circle),
                    const SizedBox(height: 16),
                    _buildTextFormField(
                      controller: _weightController,
                      label: 'Weight (kg)',
                      hint: 'Enter weight in kilograms',
                      prefixIcon: Iconsax.weight,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    _buildTextFormField(
                      controller: _colorController,
                      label: 'Color',
                      hint: 'Enter pet\'s color',
                      prefixIcon: Iconsax.colorfilter,
                    ),
                    const SizedBox(height: 16),
                    _buildDatePicker(),
                    const SizedBox(height: 24),

                    // Add Pet Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _addPet,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Add Pet',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData prefixIcon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(prefixIcon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: _selectBirthDate,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[400]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Iconsax.calendar_1),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Birth Date (Optional)',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _selectedBirthDate != null
                        ? '${_selectedBirthDate!.day}/${_selectedBirthDate!.month}/${_selectedBirthDate!.year}'
                        : 'Select birth date',
                    style: TextStyle(
                      fontSize: 16,
                      color: _selectedBirthDate != null ? Colors.black : Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            if (_selectedBirthDate != null)
              IconButton(
                onPressed: () => setState(() => _selectedBirthDate = null),
                icon: const Icon(Icons.close, size: 20),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectBirthDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDate ?? DateTime.now().subtract(const Duration(days: 365)),
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 30)),
      lastDate: DateTime.now(),
    );
    
    if (date != null) {
      setState(() => _selectedBirthDate = date);
    }
  }

  Future<void> _addPet() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final pet = Pet(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        ownerId: 'current_user', // This would come from auth service
        name: _nameController.text.trim(),
        species: _selectedSpecies,
        breed: _breedController.text.trim(),
        age: int.parse(_ageController.text),
        gender: _selectedGender,
        weight: _weightController.text.isNotEmpty ? double.tryParse(_weightController.text) : null,
        color: _colorController.text.trim().isNotEmpty ? _colorController.text.trim() : null,
        birthDate: _selectedBirthDate,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await ref.read(petsProvider.notifier).addPet(pet);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${pet.name} added successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add pet: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
