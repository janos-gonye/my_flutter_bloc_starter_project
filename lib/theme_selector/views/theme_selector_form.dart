import 'package:flutter/material.dart';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:string_validator/string_validator.dart';

import 'package:my_flutter_bloc_starter_project/theme_selector/theme_selector.dart';

class ThemeSelectorForm extends StatelessWidget {
  const ThemeSelectorForm({Key? key}) : super(key: key);

  _scheme2String(FlexScheme scheme) {
    String txt = '';
    for (var char in scheme.toString().split('.')[1].characters) {
      if (isUppercase(char)) {
        txt += ' ';
      }
      txt += char.toLowerCase();
    }
    return txt;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<ThemeSelectorBloc, ThemeSelectorState>(
          builder: (context, state) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Color Scheme: '),
                DropdownButton<FlexScheme>(
                  onChanged: (scheme) {
                    if (scheme != null) {
                      BlocProvider.of<ThemeSelectorBloc>(context).add(
                        ThemeSelectorSchemeSelected(scheme),
                      );
                    }
                  },
                  value: state.scheme,
                  items: FlexScheme.values.map(
                    (FlexScheme scheme) {
                      return DropdownMenuItem<FlexScheme>(
                        value: scheme,
                        child: Text(_scheme2String(scheme)),
                      );
                    },
                  ).toList(),
                ),
              ],
            );
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Use System Theme'),
            BlocBuilder<ThemeSelectorBloc, ThemeSelectorState>(
              builder: (context, state) {
                return Checkbox(
                  value: state.systemTheme,
                  onChanged: (bool? value) {
                    if (value != null) {
                      BlocProvider.of<ThemeSelectorBloc>(context).add(
                        ThemeSelectorSystemThemeCheckboxChanged(value),
                      );
                    }
                  },
                );
              },
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.light_mode),
            BlocBuilder<ThemeSelectorBloc, ThemeSelectorState>(
              builder: (context, state) {
                return Switch(
                  value:
                      state.selectedThemeMode == ThemeMode.light ? false : true,
                  onChanged: state.systemTheme
                      ? null
                      : (bool? value) {
                          if (value != null) {
                            BlocProvider.of<ThemeSelectorBloc>(context).add(
                              ThemeSelectorThemeModeSwitchChanged(value),
                            );
                          }
                        },
                );
              },
            ),
            const Icon(Icons.dark_mode),
          ],
        ),
      ],
    );
  }
}
