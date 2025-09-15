import 'package:flutter/foundation.dart';
import 'package:pawfect_care/core/services/notification_service.dart';
import 'package:pawfect_care/core/services/firebase_auth_service.dart';

class PetService {
  static final PetService _instance = PetService._internal();
  factory PetService() => _instance;
  PetService._internal();

  // Services are available for future use
  // final NotificationService _notificationService = NotificationService();
  // final FirebaseAuthService _authService = FirebaseAuthService();

  // Add new pet to shelter
  Future<String> addNewPet({
    required String shelterId,
    required String name,
    required String species,
    required String breed,
    required int age,
    required String gender,
    required String description,
    required List<String> imageUrls,
    required String healthStatus,
    required String temperament,
    required bool isAvailable,
    required double adoptionFee,
  }) async {
    if (kIsWeb) {
      // For web platform, return a mock pet ID
      final petId = 'pet_${DateTime.now().millisecondsSinceEpoch}';

      // Simulate notification
      await _notifyUsersAboutNewPet(
        petId: petId,
        petName: name,
        petType: '$species - $breed',
        shelterName: 'Demo Shelter',
        imageUrl: imageUrls.isNotEmpty ? imageUrls.first : null,
      );

      return petId;
    }

    // For non-web platforms, you would implement Firebase logic here
    throw UnsupportedError(
      'PetService.addNewPet is not implemented for non-web platforms',
    );
  }

  // Get all available pets
  Future<List<Map<String, dynamic>>> getAvailablePets({
    String? species,
    String? breed,
    int? minAge,
    int? maxAge,
    String? gender,
    double? maxAdoptionFee,
  }) async {
    if (kIsWeb) {
      // Return mock data for web platform
      return [
        {
          'id': 'pet_1',
          'name': 'Bella',
          'species': 'Dog',
          'breed': 'Golden Retriever',
          'age': 3,
          'gender': 'Female',
          'description': 'Friendly and energetic dog',
          'imageUrls': ['assets/images/dog1.jpg'],
          'healthStatus': 'Healthy',
          'temperament': 'Friendly',
          'isAvailable': true,
          'adoptionFee': 150.0,
        },
        {
          'id': 'pet_2',
          'name': 'Max',
          'species': 'Cat',
          'breed': 'Persian',
          'age': 2,
          'gender': 'Male',
          'description': 'Calm and affectionate cat',
          'imageUrls': ['assets/images/pet1.jpg'],
          'healthStatus': 'Healthy',
          'temperament': 'Calm',
          'isAvailable': true,
          'adoptionFee': 100.0,
        },
      ];
    }

    // For non-web platforms, you would implement Firebase logic here
    throw UnsupportedError(
      'PetService.getAvailablePets is not implemented for non-web platforms',
    );
  }

  // Get pet by ID
  Future<Map<String, dynamic>?> getPetById(String petId) async {
    if (kIsWeb) {
      // Return mock data for web platform
      final pets = await getAvailablePets();
      try {
        return pets.firstWhere((pet) => pet['id'] == petId);
      } catch (e) {
        return null;
      }
    }

    // For non-web platforms, you would implement Firebase logic here
    throw UnsupportedError(
      'PetService.getPetById is not implemented for non-web platforms',
    );
  }

  // Update pet information
  Future<void> updatePet({
    required String petId,
    String? name,
    String? species,
    String? breed,
    int? age,
    String? gender,
    String? description,
    List<String>? imageUrls,
    String? healthStatus,
    String? temperament,
    bool? isAvailable,
    double? adoptionFee,
  }) async {
    if (kIsWeb) {
      // For web platform, simulate update
      print('Pet $petId updated successfully');
      return;
    }

    // For non-web platforms, you would implement Firebase logic here
    throw UnsupportedError(
      'PetService.updatePet is not implemented for non-web platforms',
    );
  }

  // Delete pet
  Future<void> deletePet(String petId) async {
    if (kIsWeb) {
      // For web platform, simulate deletion
      print('Pet $petId deleted successfully');
      return;
    }

    // For non-web platforms, you would implement Firebase logic here
    throw UnsupportedError(
      'PetService.deletePet is not implemented for non-web platforms',
    );
  }

  // Submit adoption request
  Future<void> submitAdoptionRequest({
    required String petId,
    required String adopterName,
    required String adopterEmail,
    required String adopterPhone,
    required String adoptionReason,
  }) async {
    if (kIsWeb) {
      // For web platform, simulate adoption request
      print('Adoption request submitted for pet $petId by $adopterName');

      // Get pet information
      final pet = await getPetById(petId);
      final petName = pet?['name'] ?? 'Unknown Pet';

      // Notify shelter about adoption request
      await _notifyShelterAboutAdoption(
        petId: petId,
        petName: petName,
        adopterName: adopterName,
        adopterEmail: adopterEmail,
        adopterPhone: adopterPhone,
        adoptionReason: adoptionReason,
      );

      return;
    }

    // For non-web platforms, you would implement Firebase logic here
    throw UnsupportedError(
      'PetService.submitAdoptionRequest is not implemented for non-web platforms',
    );
  }

  // Notify users about new pet
  Future<void> _notifyUsersAboutNewPet({
    required String petId,
    required String petName,
    required String petType,
    required String shelterName,
    String? imageUrl,
  }) async {
    if (kIsWeb) {
      // For web platform, simulate notification
      print(
        'Notifying users about new pet: $petName ($petType) from $shelterName',
      );
      return;
    }

    // For non-web platforms, you would implement Firebase logic here
    throw UnsupportedError(
      'PetService._notifyUsersAboutNewPet is not implemented for non-web platforms',
    );
  }

  // Notify shelter about adoption request
  Future<void> _notifyShelterAboutAdoption({
    required String petId,
    required String petName,
    required String adopterName,
    required String adopterEmail,
    required String adopterPhone,
    required String adoptionReason,
  }) async {
    if (kIsWeb) {
      // For web platform, simulate notification
      print(
        'Notifying shelter about adoption request for $petName by $adopterName',
      );
      return;
    }

    // For non-web platforms, you would implement Firebase logic here
    throw UnsupportedError(
      'PetService._notifyShelterAboutAdoption is not implemented for non-web platforms',
    );
  }

  // Upload pet image
  Future<String> uploadPetImage(String petId, String imagePath) async {
    if (kIsWeb) {
      // For web platform, return mock URL
      return 'https://example.com/pet_images/$petId/${DateTime.now().millisecondsSinceEpoch}.jpg';
    }

    // For non-web platforms, you would implement Firebase logic here
    throw UnsupportedError(
      'PetService.uploadPetImage is not implemented for non-web platforms',
    );
  }

  // Search pets
  Future<List<Map<String, dynamic>>> searchPets(String query) async {
    if (kIsWeb) {
      // For web platform, return mock search results
      final allPets = await getAvailablePets();
      final lowercaseQuery = query.toLowerCase();

      return allPets.where((pet) {
        final name = (pet['name'] ?? '').toLowerCase();
        final breed = (pet['breed'] ?? '').toLowerCase();
        final species = (pet['species'] ?? '').toLowerCase();
        final description = (pet['description'] ?? '').toLowerCase();

        return name.contains(lowercaseQuery) ||
            breed.contains(lowercaseQuery) ||
            species.contains(lowercaseQuery) ||
            description.contains(lowercaseQuery);
      }).toList();
    }

    // For non-web platforms, you would implement Firebase logic here
    throw UnsupportedError(
      'PetService.searchPets is not implemented for non-web platforms',
    );
  }
}
