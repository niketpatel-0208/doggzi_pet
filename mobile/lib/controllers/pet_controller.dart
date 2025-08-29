import 'package:get/get.dart';
import '../models/pet.dart';
import '../services/api_service.dart';

class PetController extends GetxController {
  final RxList<Pet> pets = <Pet>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isCreating = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Don't automatically fetch pets - wait for user to be logged in
  }

  Future<void> fetchPets() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final fetchedPets = await ApiService.getPets();
      pets.value = fetchedPets;
    } on ApiException catch (e) {
      errorMessage.value = e.message;
      // Don't show snackbar for network errors, let the UI handle it
    } catch (e) {
      errorMessage.value =
          'Unable to connect. Please check your internet connection and try again.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshPets() async {
    await fetchPets();
  }

  void clearPets() {
    pets.clear();
    errorMessage.value = '';
  }

  Future<bool> addPet({
    required String name,
    required String type,
    required int age,
    String notes = '',
  }) async {
    try {
      isCreating.value = true;
      errorMessage.value = '';

      // Validation
      if (name.trim().isEmpty) {
        throw Exception('Pet name cannot be empty');
      }

      if (type.trim().isEmpty) {
        throw Exception('Pet type cannot be empty');
      }

      if (age < 0) {
        throw Exception('Pet age cannot be negative');
      }

      if (age > 100) {
        throw Exception('Pet age seems unrealistic (max 100 years)');
      }

      final petData = PetCreate(
        name: name.trim(),
        type: type.trim(),
        age: age,
        notes: notes.trim(),
      );

      final newPet = await ApiService.createPet(petData);
      pets.add(newPet);

      Get.snackbar(
        'Success',
        'Pet added successfully!',
        snackPosition: SnackPosition.BOTTOM,
      );
      return true;
    } on ApiException catch (e) {
      errorMessage.value = e.message;
      Get.snackbar(
        'Error',
        'Failed to add pet: ${e.message}',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to add pet: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isCreating.value = false;
    }
  }
}
