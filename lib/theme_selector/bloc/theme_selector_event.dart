part of 'theme_selector_bloc.dart';

abstract class ThemeSelectorEvent extends Equatable {
  const ThemeSelectorEvent();
}

class ThemeSelectorSystemThemeCheckboxChanged extends ThemeSelectorEvent {
  const ThemeSelectorSystemThemeCheckboxChanged(this.checked);

  final bool checked;

  @override
  List<Object?> get props => [checked];
}

class ThemeSelectorThemeModeSwitchChanged extends ThemeSelectorEvent {
  const ThemeSelectorThemeModeSwitchChanged(this.switched);

  final bool switched;

  @override
  List<Object?> get props => [switched];
}

class ThemeSelectorSchemeSelected extends ThemeSelectorEvent {
  const ThemeSelectorSchemeSelected(this.scheme);

  final FlexScheme scheme;

  @override
  List<Object?> get props => [scheme];
}
