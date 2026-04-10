import '../../domain/domain.dart';

class UserModel extends Person {
  const UserModel({
    required super.id,
    required super.fullName,
    required super.email,
    required super.phone,
    required super.location,
    required super.avatarUrl,
    required super.age,
    required super.gender,
  });

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
}
