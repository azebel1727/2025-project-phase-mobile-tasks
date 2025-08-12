// domain/entities/user.dart
class User {
  final String id;
  final String name;
  final String? email;
  //final String? profileImageUrl;

  User({required this.id, required this.name, this.email});

  String get initial => name.isNotEmpty ? name[0].toUpperCase() : '?';

  factory User.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return User(id: '', name: '', email: '');
    }
    return User(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString(),
      //profileImageUrl: json['profileImageUrl']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email};
  }
}
