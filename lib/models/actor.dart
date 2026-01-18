import 'dart:convert';

class Actor {
  int id;
  String name;
  String profilePath;
  String biography;

  Actor({
    required this.id,
    required this.name,
    this.profilePath = '',
    this.biography = '',
  });

  factory Actor.fromMap(Map<String, dynamic> map) {
    return Actor(
      id: map['id'] as int,
      name: map['name'] ?? 'Sin nombre',
      profilePath: map['profile_path'] ?? '',
      biography: map['biography'] ?? '', 
    );
  }

  factory Actor.fromJson(String source) => Actor.fromMap(json.decode(source));
}