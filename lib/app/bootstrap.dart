import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:people_browser/app/export.dart';
import 'package:people_browser/core/export.dart';
import 'package:people_browser/data/export.dart';
import 'package:people_browser/domain/export.dart';

void bootstrap() {
  final dio = Dio(
    BaseOptions(
      connectTimeout: AppConstants.requestTimeout,
      receiveTimeout: AppConstants.requestTimeout,
    ),
  );
  final userService = UserService(dio);
  final peopleRemoteDataSource = PeopleRemoteDataSourceImpl(userService);
  final peopleRepository = PeopleRepositoryImpl(peopleRemoteDataSource);

  runApp(
    PeopleBrowserApp(
      getPeople: GetPeople(peopleRepository),
      getVisiblePeople: const GetVisiblePeople(),
    ),
  );
}
