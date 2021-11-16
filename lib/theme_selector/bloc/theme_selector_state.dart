part of 'theme_selector_bloc.dart';

class ThemeSelectorState extends Equatable {
  const ThemeSelectorState({
    this.selectedThemeMode = ThemeMode.light,
    this.systemTheme = true,
    this.scheme = FlexScheme.hippieBlue,
  });

  final ThemeMode selectedThemeMode;
  final bool systemTheme;
  final FlexScheme scheme;

  ThemeSelectorState copyWith({
    ThemeMode? selectedThemeMode,
    bool? systemTheme,
    FlexScheme? scheme,
  }) {
    return ThemeSelectorState(
      selectedThemeMode: selectedThemeMode ?? this.selectedThemeMode,
      systemTheme: systemTheme ?? this.systemTheme,
      scheme: scheme ?? this.scheme,
    );
  }

  ThemeMode get themeMode {
    if (systemTheme) {
      return ThemeMode.system;
    }
    return selectedThemeMode;
  }

  @override
  List<Object> get props => [systemTheme, selectedThemeMode, scheme];
}
