class Pet {
  final String id;
  final String name;
  final String type;
  final int age;
  final String notes;
  final DateTime createdAt;

  Pet({
    required this.id,
    required this.name,
    required this.type,
    required this.age,
    required this.notes,
    required this.createdAt,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      age: json['age'] ?? 0,
      notes: json['notes'] ?? '',
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'age': age,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class PetCreate {
  final String name;
  final String type;
  final int age;
  final String notes;

  PetCreate({
    required this.name,
    required this.type,
    required this.age,
    this.notes = '',
  });

  Map<String, dynamic> toJson() {
    return {'name': name, 'type': type, 'age': age, 'notes': notes};
  }
}
