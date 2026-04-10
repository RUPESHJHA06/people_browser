import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system);

  void updateThemeMode(ThemeMode mode) {
    if (state == mode) {
      return;
    }

    emit(mode);
  }
}
