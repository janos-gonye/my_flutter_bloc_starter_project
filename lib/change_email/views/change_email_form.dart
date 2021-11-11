import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:my_flutter_bloc_starter_project/change_email/bloc/change_email_bloc.dart';

import 'package:my_flutter_bloc_starter_project/shared/views/helpers.dart'
    as helpers;
import 'package:my_flutter_bloc_starter_project/shared/views/forms/helpers.dart'
    as form_helpers;

class ChangeEmailForm extends StatefulWidget {
  const ChangeEmailForm({Key? key}) : super(key: key);

  @override
  State<ChangeEmailForm> createState() => _ChangeEmailFormState();
}

class _ChangeEmailFormState extends State<ChangeEmailForm> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ChangeEmailBloc>(context)
        .add(const ChangeEmailFormInitialized());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChangeEmailBloc, ChangeEmailState>(
      listenWhen: (previous, current) =>
          form_helpers.shouldFormListen(previous, current),
      listener: (context, state) {
        debugPrint("'ChangeEmailForm' listener invoked");
        if (state.isEmailChangingError) {
          EasyLoading.dismiss();
          helpers.showSnackbar(context, state.message);
        }
        if (state.isEmailChangingSuccess) {
          EasyLoading.dismiss();
          helpers.showSnackbar(context, state.message);
        } else if (state.isEmailChanging) {
          EasyLoading.show(
              status: 'loading...', maskType: EasyLoadingMaskType.clear);
        } else {
          EasyLoading.dismiss();
        }
      },
      child: Column(
        children: [
          _EmailInput(),
          _EmailConfirmInput(),
          _SubmitButton(),
        ],
      ),
    );
  }
}

class _EmailInput extends StatefulWidget {
  @override
  State<_EmailInput> createState() => _EmailInputState();
}

class _EmailInputState extends State<_EmailInput> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChangeEmailBloc, ChangeEmailState>(
      buildWhen: (previous, current) =>
          form_helpers.shouldRerenderFormInputField(previous, current) ||
          previous.email != current.email,
      builder: (context, state) {
        debugPrint("'ChangeEmailForm - _PasswordInput' (re)built");
        if (_controller.text != state.email.value) {
          _controller.text = state.email.value;
        }
        return TextField(
          controller: _controller,
          onChanged: (email) => BlocProvider.of<ChangeEmailBloc>(context)
              .add(ChangeEmailEmailChanged(email)),
          decoration: InputDecoration(
            labelText: 'email',
            errorText: state.isInitial ? null : state.email.errorMessage,
          ),
        );
      },
    );
  }
}

class _EmailConfirmInput extends StatefulWidget {
  @override
  State<_EmailConfirmInput> createState() => _EmailConfirmInputState();
}

class _EmailConfirmInputState extends State<_EmailConfirmInput> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChangeEmailBloc, ChangeEmailState>(
      buildWhen: (previous, current) =>
          form_helpers.shouldRerenderFormInputField(previous, current) ||
          previous.email != current.email ||
          previous.emailConfirm != current.emailConfirm,
      builder: (context, state) {
        debugPrint("'ChangeEmailForm - _EmailConfirmInput' (re)built");
        if (_controller.text != state.emailConfirm.value) {
          _controller.text = state.emailConfirm.value;
        }
        return TextField(
          controller: _controller,
          onChanged: (emailConfirm) => BlocProvider.of<ChangeEmailBloc>(context)
              .add(ChangeEmailEmailConfirmChanged(emailConfirm)),
          decoration: InputDecoration(
            labelText: 'confirm email',
            errorText: state.isInitial
                ? null
                : state.email.value != state.emailConfirm.value
                    ? "emails don't match"
                    : null,
          ),
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChangeEmailBloc, ChangeEmailState>(
      buildWhen: (previous, current) =>
          form_helpers.shouldRerenderFormSubmitButton(previous, current),
      builder: (context, state) {
        debugPrint("'ChangeEmailForm - _SubmitButton' (re)built");
        return ElevatedButton(
          child: const Text('Save new email'),
          onPressed: state.invalid || state.isInProgress
              ? null
              : () {
                  BlocProvider.of<ChangeEmailBloc>(context)
                      .add(const ChangeEmailFormSubmitted());
                },
        );
      },
    );
  }
}
