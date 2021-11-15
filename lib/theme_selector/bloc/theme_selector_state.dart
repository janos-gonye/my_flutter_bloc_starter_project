part of 'theme_selector_bloc.dart';

class ThemeSelectorState extends Equatable {
  const ThemeSelectorState({
    this.selectedThemeMode = ThemeMode.light,
    this.systemTheme = true,
  });

  final ThemeMode selectedThemeMode;
  final bool systemTheme;

  ThemeSelectorState copyWith({
    ThemeMode? selectedThemeMode,
    bool? systemTheme,
  }) {
    return ThemeSelectorState(
      selectedThemeMode: selectedThemeMode ?? this.selectedThemeMode,
      systemTheme: systemTheme ?? this.systemTheme,
    );
  }

  ThemeMode get themeMode {
    if (systemTheme) {
      return ThemeMode.system;
    }
    return selectedThemeMode;
  }

  @override
  List<Object> get props => [systemTheme, selectedThemeMode];
}
