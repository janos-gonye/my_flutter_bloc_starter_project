import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:my_flutter_bloc_starter_project/app_settings/bloc/app_settings_bloc.dart';
import 'package:my_flutter_bloc_starter_project/constants.dart';
import 'package:my_flutter_bloc_starter_project/home/views/home_page.dart';

import 'package:my_flutter_bloc_starter_project/shared/views/helpers.dart'
    as helpers;
import 'package:my_flutter_bloc_starter_project/shared/views/forms/helpers.dart'
    as form_helpers;

class AppSettingsForm extends StatefulWidget {
  const AppSettingsForm({Key? key}) : super(key: key);

  @override
  State<AppSettingsForm> createState() => _AppSettingsFormState();
}

class _AppSettingsFormState extends State<AppSettingsForm> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<AppSettingsBloc>(context)
        .add(const AppSettingsFormInitialized());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppSettingsBloc, AppSettingsState>(
      listenWhen: (previous, current) =>
          form_helpers.shouldFormListen(previous, current),
      listener: (context, state) {
        debugPrint("'AppSettingsForm' listener invoked");
        if (state.isSaving) {
          EasyLoading.show(
              status: 'loading...', maskType: EasyLoadingMaskType.clear);
        } else {
          EasyLoading.dismiss();
        }
        if (state.isSavingSuccess) {
          EasyLoading.dismiss();
          helpers.showSnackbar(context, state.message);
          Navigator.of(context).pushNamedAndRemoveUntil(
            HomePage.routeName,
            (route) => false,
          );
        } else if (state.isSavingError) {
          EasyLoading.dismiss();
          helpers.showSnackbar(context, state.message);
        }
      },
      child: BlocBuilder<AppSettingsBloc, AppSettingsState>(
        buildWhen: (previous, current) =>
            (previous.type != current.type) &&
            (previous.isloading || current.isloading),
        builder: (context, state) {
          debugPrint("'AppSettingsForm' (re)built");
          if (state.isloading) {
            return const CircularProgressIndicator();
          } else {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('Protocol: '),
                    _ProtocolInput(),
                  ],
                ),
                const _HostnameInput(),
                const _PortInput(),
                const _SubmitButton(),
              ],
            );
          }
        },
      ),
    );
  }
}

class _ProtocolInput extends StatelessWidget {
  const _ProtocolInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppSettingsBloc, AppSettingsState>(
      buildWhen: (previous, current) => previous.protocol != current.protocol,
      builder: (context, state) {
        debugPrint("'AppSettingsForm - _ProtocolInput' (re)built");
        return DropdownButton<String>(
          onChanged: (protocol) {
            if (protocol != null) {
              BlocProvider.of<AppSettingsBloc>(context)
                  .add(AppSettingsProtocolUpdated(protocol));
            }
          },
          value: state.protocol.value,
          items: protocols.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        );
      },
    );
  }
}

class _HostnameInput extends StatefulWidget {
  const _HostnameInput({Key? key}) : super(key: key);

  @override
  State<_HostnameInput> createState() => _HostnameInputState();
}

class _HostnameInputState extends State<_HostnameInput> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppSettingsBloc, AppSettingsState>(
      buildWhen: (previous, current) =>
          form_helpers.shouldRerenderFormInputField(previous, current) ||
          previous.hostname != current.hostname,
      builder: (context, state) {
        debugPrint("'AppSettingsForm - _HostnameInput' (re)built");
        if (_controller.text != state.hostname.value) {
          _controller.text = state.hostname.value;
        }
        return TextField(
          controller: _controller,
          onChanged: (hostname) {
            BlocProvider.of<AppSettingsBloc>(context)
                .add(AppSettingsHostnameUpdated(hostname));
          },
          decoration: InputDecoration(
            labelText: 'hostname',
            errorText: state.isInitial ? null : state.hostname.errorMessage,
          ),
        );
      },
    );
  }
}

class _PortInput extends StatefulWidget {
  const _PortInput({Key? key}) : super(key: key);

  @override
  State<_PortInput> createState() => _PortInputState();
}

class _PortInputState extends State<_PortInput> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppSettingsBloc, AppSettingsState>(
      buildWhen: (previous, current) =>
          form_helpers.shouldRerenderFormInputField(previous, current) ||
          previous.port != current.port,
      builder: (context, state) {
        debugPrint("'AppSettingsForm - _PortInput' (re)built");
        if (_controller.text != state.port.value) {
          _controller.text = state.port.value;
        }
        return TextField(
          controller: _controller,
          onChanged: (port) {
            BlocProvider.of<AppSettingsBloc>(context)
                .add(AppSettingsPortUpdated(port));
          },
          decoration: InputDecoration(
            labelText: 'port',
            errorText: state.isInitial ? null : state.port.errorMessage,
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppSettingsBloc, AppSettingsState>(
      buildWhen: (previous, current) =>
          form_helpers.shouldRerenderFormSubmitButton(previous, current),
      builder: (context, state) {
        debugPrint("'AppSettingsForm - _SubmitButton' (re)built");
        return ElevatedButton(
          onPressed: state.invalid || state.isInProgress
              ? null
              : () {
                  BlocProvider.of<AppSettingsBloc>(context)
                      .add(const AppSettingsFormSubmitted());
                },
          child: const Text('Save'),
        );
      },
    );
  }
}
