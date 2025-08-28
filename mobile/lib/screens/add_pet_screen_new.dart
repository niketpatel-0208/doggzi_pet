import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/pet_controller.dart';

class AddPetScreen extends StatefulWidget {
  const AddPetScreen({super.key});

  @override
  State<AddPetScreen> createState() => _AddPetScreenState();
}

class _AddPetScreenState extends State<AddPetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _typeController = TextEditingController();
  final _ageController = TextEditingController();
  final _notesController = TextEditingController();
  final _petController = Get.find<PetController>();

  // Focus nodes for keyboard navigation
  final _nameFocusNode = FocusNode();
  final _ageFocusNode = FocusNode();
  final _notesFocusNode = FocusNode();

  final List<String> _petTypes = [
    'Dog',
    'Cat',
    'Bird',
    'Fish',
    'Rabbit',
    'Hamster',
    'Guinea Pig',
    'Turtle',
    'Snake',
    'Lizard',
    'Other',
  ];

  String? _selectedType;

  @override
  void dispose() {
    _nameController.dispose();
    _typeController.dispose();
    _ageController.dispose();
    _notesController.dispose();
    _nameFocusNode.dispose();
    _ageFocusNode.dispose();
    _notesFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Pet'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          // Dismiss keyboard when tapping outside
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 16.0,
              bottom: keyboardHeight > 0 ? keyboardHeight + 16.0 : 16.0,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    screenSize.height -
                    AppBar().preferredSize.height -
                    MediaQuery.of(context).padding.top -
                    keyboardHeight -
                    32,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(
                      Icons.add_circle_outline,
                      size: screenSize.width * 0.15,
                      color: Colors.blue,
                    ),
                    SizedBox(height: screenSize.height * 0.02),
                    Text(
                      'Add a new pet',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: screenSize.height * 0.03),
                    TextFormField(
                      controller: _nameController,
                      focusNode: _nameFocusNode,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        // Move focus to age field after dropdown selection
                        FocusScope.of(context).requestFocus(_ageFocusNode);
                      },
                      decoration: const InputDecoration(
                        labelText: 'Pet Name *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.pets),
                        hintText: 'Enter your pet\'s name',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Pet name is required';
                        }
                        if (value.trim().length < 2) {
                          return 'Pet name must be at least 2 characters';
                        }
                        if (value.trim().length > 50) {
                          return 'Pet name must be less than 50 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedType,
                      decoration: const InputDecoration(
                        labelText: 'Pet Type *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.category),
                      ),
                      items: _petTypes.map((type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedType = value;
                          if (value == 'Other') {
                            _typeController.clear();
                          } else {
                            _typeController.text = value ?? '';
                          }
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a pet type';
                        }
                        return null;
                      },
                    ),
                    if (_selectedType == 'Other') ...[
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _typeController,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_ageFocusNode);
                        },
                        decoration: const InputDecoration(
                          labelText: 'Specify Pet Type *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.edit),
                          hintText: 'Enter specific pet type',
                        ),
                        validator: (value) {
                          if (_selectedType == 'Other' &&
                              (value == null || value.trim().isEmpty)) {
                            return 'Please specify the pet type';
                          }
                          if (_selectedType == 'Other' &&
                              value != null &&
                              value.trim().length > 30) {
                            return 'Pet type must be less than 30 characters';
                          }
                          return null;
                        },
                      ),
                    ],
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _ageController,
                      focusNode: _ageFocusNode,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_notesFocusNode);
                      },
                      decoration: const InputDecoration(
                        labelText: 'Age (years) *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.cake),
                        hintText: 'Enter age in years',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Pet age is required';
                        }
                        final age = int.tryParse(value);
                        if (age == null) {
                          return 'Please enter a valid number';
                        }
                        if (age < 0) {
                          return 'Age cannot be negative';
                        }
                        if (age > 100) {
                          return 'Age seems unrealistic (max 100 years)';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _notesController,
                      focusNode: _notesFocusNode,
                      maxLines: 4,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) {
                        if (!_petController.isCreating.value) {
                          _handleAddPet();
                        }
                      },
                      decoration: const InputDecoration(
                        labelText: 'Notes (Optional)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.note),
                        hintText:
                            'Any additional information about your pet...',
                        alignLabelWithHint: true,
                      ),
                      validator: (value) {
                        if (value != null && value.length > 500) {
                          return 'Notes must be less than 500 characters';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: screenSize.height * 0.03),
                    Obx(
                      () => ElevatedButton(
                        onPressed: _petController.isCreating.value
                            ? null
                            : () => _handleAddPet(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _petController.isCreating.value
                            ? const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Text('Adding Pet...'),
                                ],
                              )
                            : const Text(
                                'Add Pet',
                                style: TextStyle(fontSize: 16),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: _petController.isCreating.value
                          ? null
                          : () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                    // Add some extra space at the bottom to prevent overflow
                    SizedBox(height: screenSize.height * 0.02),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleAddPet() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    final name = _nameController.text.trim();
    final type = _selectedType == 'Other'
        ? _typeController.text.trim()
        : _selectedType ?? '';
    final age = int.parse(_ageController.text.trim());
    final notes = _notesController.text.trim();

    final success = await _petController.addPet(
      name: name,
      type: type,
      age: age,
      notes: notes,
    );

    if (success) {
      // Show success message and navigate back
      Get.snackbar(
        'Success',
        'Pet "$name" has been added successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      // Clear the form
      _nameController.clear();
      _typeController.clear();
      _ageController.clear();
      _notesController.clear();
      setState(() {
        _selectedType = null;
      });

      // Wait briefly for the snackbar to show, then navigate back
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) {
        Get.back();
      }
    }
  }
}
