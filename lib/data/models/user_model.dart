import 'package:people_browser/domain/export.dart';

class UserModel {
  const UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.location,
    required this.avatarUrl,
    required this.age,
    required this.gender,
  });

  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String location;
  final String avatarUrl;
  final int age;
  final String gender;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final name = json['name'] as Map<String, dynamic>? ?? {};
    final login = json['login'] as Map<String, dynamic>? ?? {};
    final picture = json['picture'] as Map<String, dynamic>? ?? {};
    final dob = json['dob'] as Map<String, dynamic>? ?? {};
    final location = json['location'] as Map<String, dynamic>? ?? {};
    final street = location['street'] as Map<String, dynamic>? ?? {};

    final firstName = name['first'] as String? ?? '';
    final lastName = name['last'] as String? ?? '';
    final city = location['city'] as String? ?? '';
    final country = location['country'] as String? ?? '';
    final streetName = street['name'] as String? ?? '';

    return UserModel(
      id: login['uuid'] as String? ?? json['email'] as String? ?? '',
      fullName: [
        firstName,
        lastName,
      ].where((part) => part.isNotEmpty).join(' '),
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      location: [
        streetName,
        city,
        country,
      ].where((part) => part.isNotEmpty).join(', '),
      avatarUrl: picture['large'] as String? ?? '',
      age: dob['age'] as int? ?? 0,
      gender: json['gender'] as String? ?? 'unknown',
    );
  }

  Person toEntity() {
    return Person(
      id: id,
      fullName: fullName,
      email: email,
      phone: phone,
      location: location,
      avatarUrl: avatarUrl,
      age: age,
      gender: gender,
    );
  }
}
