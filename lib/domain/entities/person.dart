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
}
