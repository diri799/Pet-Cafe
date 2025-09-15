class Pet {
  final String id;
  final String name;
  final String breed;
  final String age;
  final String imageUrl;
  final String description;
  final String ownerId;
  final String gender;
  final String location;
  final bool isFavorite;

  Pet({
    required this.id,
    required this.name,
    required this.breed,
    required this.age,
    required this.imageUrl,
    required this.description,
    required this.ownerId,
    required this.gender,
    required this.location,
    required this.isFavorite,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'],
      name: json['name'],
      breed: json['breed'],
      age: json['age'],
      imageUrl: json['imageUrl'],
      description: json['description'],
      ownerId: json['ownerId'],
      gender: json['gender'],
      location: json['location'],
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'breed': breed,
      'age': age,
      'imageUrl': imageUrl,
      'description': description,
      'ownerId': ownerId,
      'gender': gender,
      'location': location,
      'isFavorite': isFavorite,
    };
  }
}

