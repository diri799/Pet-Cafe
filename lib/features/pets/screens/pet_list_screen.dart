import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pawfect_care/core/theme/app_theme.dart';
import 'package:pawfect_care/core/widgets/custom_app_bar.dart';
import 'package:pawfect_care/features/pets/providers/pet_provider.dart';
import 'package:pawfect_care/features/pets/models/pet_model.dart';

class PetListScreen extends ConsumerWidget {
  const PetListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pets = ref.watch(petsProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'My Pets',
        additionalActions: [
          IconButton(
            icon: const Icon(Iconsax.add),
            onPressed: () => context.go('/pets/add'),
          ),
        ],
      ),
      body: pets.isEmpty
          ? _buildEmptyState(context)
          : _buildPetList(context, pets),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/pets/add'),
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Iconsax.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.pet, size: 100, color: Colors.grey[400]),
          const SizedBox(height: 24),
          Text(
            'No Pets Added Yet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first pet to get started',
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => context.go('/pets/add'),
            icon: const Icon(Iconsax.add),
            label: const Text('Add Pet'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPetList(BuildContext context, List<Pet> pets) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: pets.length,
      itemBuilder: (context, index) {
        final pet = pets[index];
        return _buildPetCard(context, pet);
      },
    );
  }

  Widget _buildPetCard(BuildContext context, Pet pet) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => context.go('/pets/${pet.id}'),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Pet Photo
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  image: pet.photo != null
                      ? DecorationImage(
                          image: NetworkImage(pet.photo!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: pet.photo == null
                    ? Icon(
                        _getPetIcon(pet.species),
                        size: 40,
                        color: Colors.grey[400],
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              // Pet Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pet.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${pet.species} • ${pet.breed}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Iconsax.calendar,
                          size: 14,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${pet.age} months old',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(Iconsax.user, size: 14, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(
                          pet.gender,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                    if (pet.weight != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Iconsax.weight,
                            size: 14,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${pet.weight} kg',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              // Actions
              Column(
                children: [
                  IconButton(
                    onPressed: () => context.go('/pets/${pet.id}/edit'),
                    icon: const Icon(Iconsax.edit),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.blue[50],
                      foregroundColor: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  IconButton(
                    onPressed: () => _showDeleteDialog(context, pet),
                    icon: const Icon(Iconsax.trash),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.red[50],
                      foregroundColor: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getPetIcon(String species) {
    switch (species.toLowerCase()) {
      case 'dog':
        return Icons.pets;
      case 'cat':
        return Icons.pets;
      case 'bird':
        return Icons.pets;
      case 'fish':
        return Icons.pets;
      default:
        return Icons.pets;
    }
  }

  void _showDeleteDialog(BuildContext context, Pet pet) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Pet'),
        content: Text(
          'Are you sure you want to delete ${pet.name}? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implement delete functionality
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${pet.name} deleted successfully'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
