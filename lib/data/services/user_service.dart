import 'package:dio/dio.dart';
import 'package:people_browser/core/export.dart';
import 'package:people_browser/data/export.dart';

class UserService {
  final Dio dio;

  UserService(this.dio);

  Future<List<UserModel>> fetchUsers() async {
    final response = await dio.get<Map<String, dynamic>>(
      AppConstants.randomUserUrl,
      queryParameters: const {
        'results': AppConstants.peopleResultCount,
        'seed': AppConstants.peopleSeed,
        'nat': AppConstants.peopleNationalities,
      },
    );

    final list = response.data?['results'] as List<dynamic>? ?? const [];

    return list
        .whereType<Map<String, dynamic>>()
        .map(UserModel.fromJson)
        .toList();
  }
}
