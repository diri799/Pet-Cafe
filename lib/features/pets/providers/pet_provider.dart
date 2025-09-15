import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pawfect_care/features/pets/models/pet_model.dart';
import 'package:pawfect_care/core/services/user_service.dart';

class PetNotifier extends StateNotifier<List<Pet>> {
  final UserService _userService = UserService();
  
  PetNotifier() : super([]) {
    _loadPets();
  }

  Future<void> _loadPets() async {
    try {
      final petsData = await _userService.getPets();
      final pets = petsData.map((data) => Pet.fromMap(data)).toList();
      
      if (mounted) {
        state = pets;
      }
    } catch (e) {
      print('Failed to load pets: $e');
      if (mounted) {
        state = [];
      }
    }
  }

  Future<void> addPet(Pet pet) async {
    try {
      await _userService.addPet(pet.toMap());
      
      // Update local state
      state = [...state, pet];
    } catch (e) {
      print('Failed to add pet: $e');
      rethrow;
    }
  }

  Future<void> updatePet(Pet pet) async {
    try {
      await _userService.updatePet(pet.id, pet.toMap());
      
      // Update local state
      final index = state.indexWhere((p) => p.id == pet.id);
      if (index != -1) {
        state = [
          ...state.sublist(0, index),
          pet,
          ...state.sublist(index + 1),
        ];
      }
    } catch (e) {
      print('Failed to update pet: $e');
      rethrow;
    }
  }

  Future<void> deletePet(String petId) async {
    try {
      await _userService.deletePet(petId);
      
      // Update local state
      state = state.where((pet) => pet.id != petId).toList();
    } catch (e) {
      print('Failed to delete pet: $e');
      rethrow;
    }
  }

  void refresh() {
    _loadPets();
  }
}

final petsProvider = StateNotifierProvider<PetNotifier, List<Pet>>(
  (ref) => PetNotifier(),
);

// Individual pet provider
final petProvider = Provider.family<Pet?, String>((ref, petId) {
  final pets = ref.watch(petsProvider);
  try {
    return pets.firstWhere((pet) => pet.id == petId);
  } catch (e) {
    return null;
  }
});
