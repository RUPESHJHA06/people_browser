class Person {
  const Person({
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is Person &&
        other.id == id &&
        other.fullName == fullName &&
        other.email == email &&
        other.phone == phone &&
        other.location == location &&
        other.avatarUrl == avatarUrl &&
        other.age == age &&
        other.gender == gender;
  }

  @override
  int get hashCode =>
      Object.hash(id, fullName, email, phone, location, avatarUrl, age, gender);
}
