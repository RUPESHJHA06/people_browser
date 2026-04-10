import 'package:flutter_test/flutter_test.dart';
import 'package:people_browser/data/data.dart';

void main() {
  test('maps Random User API json into a user model', () {
    final model = UserModel.fromJson(const {
      'gender': 'female',
      'name': {'first': 'Jane', 'last': 'Doe'},
      'location': {
        'street': {'name': 'Main Street'},
        'city': 'Toronto',
        'country': 'Canada',
      },
      'email': 'jane.doe@example.com',
      'login': {'uuid': 'person-1'},
      'dob': {'age': 32},
      'phone': '555-0100',
      'picture': {'large': 'https://example.com/jane.jpg'},
    });

    expect(model.id, 'person-1');
    expect(model.fullName, 'Jane Doe');
    expect(model.email, 'jane.doe@example.com');
    expect(model.location, 'Main Street, Toronto, Canada');
    expect(model.age, 32);
    expect(model.avatarUrl, 'https://example.com/jane.jpg');
  });
}
