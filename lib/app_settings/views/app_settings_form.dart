import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:formz/formz.dart';

import 'package:my_flutter_bloc_starter_project/app_settings/bloc/app_settings_bloc.dart';

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
        .add(const AppSettingsInitialized());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppSettingsBloc, AppSettingsState>(
      listenWhen: (previous, current) =>
          previous.formStatus != current.formStatus,
      listener: (context, state) {
        if (state.formStatus == FormzStatus.submissionInProgress) {
          EasyLoading.show(
              status: 'loading...', maskType: EasyLoadingMaskType.clear);
        } else {
          EasyLoading.dismiss();
        }
        if (state.formStatus.isSubmissionSuccess) {
          EasyLoading.showSuccess('Settings saved');
        } else if (state.formStatus.isSubmissionFailure) {
          EasyLoading.showError('Saving settings failed');
        }
      },
      child: BlocBuilder<AppSettingsBloc, AppSettingsState>(
        buildWhen: (previous, current) => previous.fetching != current.fetching,
        builder: (context, state) {
          if (state.fetching) {
            return const SizedBox();
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
        return DropdownButton<String>(
          onChanged: (protocol) {
            if (protocol != null) {
              BlocProvider.of<AppSettingsBloc>(context)
                  .add(AppSettingsProtocolUpdated(protocol));
            }
          },
          value: state.protocol.value,
          items: <String>['http', 'https']
              .map<DropdownMenuItem<String>>((String value) {
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

class _HostnameInput extends StatelessWidget {
  const _HostnameInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppSettingsBloc, AppSettingsState>(
      buildWhen: (previous, current) => previous.hostname != current.hostname,
      builder: (context, state) {
        return TextFormField(
          initialValue: state.hostname.value,
          onChanged: (hostname) {
            BlocProvider.of<AppSettingsBloc>(context)
                .add(AppSettingsHostnameUpdated(hostname));
          },
          decoration: InputDecoration(
            labelText: 'hostname',
            errorText: state.hostname.errorMessage,
          ),
        );
      },
    );
  }
}

class _PortInput extends StatelessWidget {
  const _PortInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppSettingsBloc, AppSettingsState>(
      buildWhen: (previous, current) => previous.port != current.port,
      builder: (context, state) {
        return TextFormField(
          initialValue: state.port.value,
          onChanged: (port) {
            BlocProvider.of<AppSettingsBloc>(context)
                .add(AppSettingsPortUpdated(port));
          },
          decoration: InputDecoration(
            labelText: 'port',
            errorText: state.port.errorMessage,
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
          previous.formStatus != current.formStatus,
      builder: (context, state) {
        return ElevatedButton(
          onPressed: state.fetching ||
                  state.formStatus.isSubmissionInProgress ||
                  state.formStatus.isInvalid
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
