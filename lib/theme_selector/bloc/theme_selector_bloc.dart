import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'theme_selector_event.dart';
part 'theme_selector_state.dart';

class ThemeSelectorBloc extends Bloc<ThemeSelectorEvent, ThemeSelectorState> {
  ThemeSelectorBloc()
      : super(const ThemeSelectorState(
          systemTheme: true,
          selectedThemeMode: ThemeMode.light,
        )) {
    on<ThemeSelectorSystemThemeCheckboxChanged>(_onSystemThemeCheckboxChanged);
    on<ThemeSelectorThemeModeSwitchChanged>(_onThemeModeSwitchChanged);
  }

  @override
  void onTransition(
    Transition<ThemeSelectorEvent, ThemeSelectorState> transition,
  ) {
    debugPrint(transition.toString());
    super.onTransition(transition);
  }

  void _onSystemThemeCheckboxChanged(
    ThemeSelectorSystemThemeCheckboxChanged event,
    Emitter<ThemeSelectorState> emit,
  ) async {
    emit(state.copyWith(systemTheme: event.checked));
  }

  void _onThemeModeSwitchChanged(
    ThemeSelectorThemeModeSwitchChanged event,
    Emitter<ThemeSelectorState> emit,
  ) async {
    emit(state.copyWith(
      selectedThemeMode: event.switched ? ThemeMode.dark : ThemeMode.light,
    ));
  }
}
