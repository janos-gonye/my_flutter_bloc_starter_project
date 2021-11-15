import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:my_flutter_bloc_starter_project/theme_selector/theme_selector.dart';

class ThemeSelectorForm extends StatelessWidget {
  const ThemeSelectorForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
        )
      ],
    );
  }
}
