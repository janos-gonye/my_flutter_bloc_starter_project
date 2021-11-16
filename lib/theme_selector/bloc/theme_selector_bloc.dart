import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'theme_selector_event.dart';
part 'theme_selector_state.dart';

class ThemeSelectorBloc extends Bloc<ThemeSelectorEvent, ThemeSelectorState>
    with HydratedMixin {
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

  @override
  ThemeSelectorState? fromJson(Map<String, dynamic> json) => ThemeSelectorState(
        systemTheme: json['systemTheme'],
        selectedThemeMode: json['selectedThemeMode'] == 'dark'
            ? ThemeMode.dark
            : ThemeMode.light,
      );

  @override
  Map<String, dynamic>? toJson(ThemeSelectorState state) => {
        'systemTheme': state.systemTheme,
        'selectedThemeMode':
            state.selectedThemeMode == ThemeMode.dark ? 'dark' : 'light',
      };
}
