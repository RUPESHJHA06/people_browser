import 'package:dio/dio.dart';

import '../../core/core.dart';
import '../models/user_model.dart';

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
