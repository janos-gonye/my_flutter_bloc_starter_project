import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:my_flutter_bloc_starter_project/change_password/bloc/change_password_bloc.dart';

import 'package:my_flutter_bloc_starter_project/shared/views/helpers.dart'
    as helpers;
import 'package:my_flutter_bloc_starter_project/shared/views/forms/helpers.dart'
    as form_helpers;

class ChangePasswordForm extends StatefulWidget {
  const ChangePasswordForm({Key? key}) : super(key: key);

  @override
  State<ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ChangePasswordBloc>(context)
        .add(const ChangePasswordFormInitialized());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChangePasswordBloc, ChangePasswordState>(
      listenWhen: (previous, current) =>
          form_helpers.shouldFormListen(previous, current),
      listener: (context, state) {
        debugPrint("'ChangePasswordForm' listener invoked");
        if (state.isPasswordChangingError) {
          EasyLoading.dismiss();
          helpers.showSnackbar(context, state.message);
        }
        if (state.isPasswordChangingSuccess) {
          EasyLoading.dismiss();
          helpers.showSnackbar(context, state.message);
        } else if (state.isPasswordChanging) {
          EasyLoading.show(
              status: 'loading...', maskType: EasyLoadingMaskType.clear);
        } else {
          EasyLoading.dismiss();
        }
      },
      child: Column(
        children: [
          _CurrentPasswordInput(),
          _NewPasswordInput(),
          _NewPasswordConfirmInput(),
          _SubmitButton(),
        ],
      ),
    );
  }
}

class _CurrentPasswordInput extends StatefulWidget {
  @override
  State<_CurrentPasswordInput> createState() => _CurrentPasswordInputState();
}

class _CurrentPasswordInputState extends State<_CurrentPasswordInput> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
      buildWhen: (previous, current) =>
          form_helpers.shouldRerenderFormInputField(previous, current) ||
          previous.currentPassword != current.currentPassword,
      builder: (context, state) {
        debugPrint("'ChangePasswordForm - _PasswordInput' (re)built");
        if (_controller.text != state.currentPassword.value) {
          _controller.text = state.currentPassword.value;
        }
        return TextField(
          controller: _controller,
          onChanged: (currentPassword) =>
              BlocProvider.of<ChangePasswordBloc>(context)
                  .add(ChangePasswordCurrentPasswordChanged(currentPassword)),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'current password',
            errorText:
                state.isInitial ? null : state.currentPassword.errorMessage,
          ),
        );
      },
    );
  }
}

class _NewPasswordInput extends StatefulWidget {
  @override
  State<_NewPasswordInput> createState() => _NewPasswordInputState();
}

class _NewPasswordInputState extends State<_NewPasswordInput> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
      buildWhen: (previous, current) =>
          form_helpers.shouldRerenderFormInputField(previous, current) ||
          previous.newPassword != current.newPassword,
      builder: (context, state) {
        debugPrint("'ChangePasswordForm - _NewPasswordInput' (re)built");
        if (_controller.text != state.newPassword.value) {
          _controller.text = state.newPassword.value;
        }
        return TextField(
          controller: _controller,
          onChanged: (password) => BlocProvider.of<ChangePasswordBloc>(context)
              .add(ChangePasswordNewPasswordChanged(password)),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'new password',
            errorText: state.isInitial ? null : state.newPassword.errorMessage,
          ),
        );
      },
    );
  }
}

class _NewPasswordConfirmInput extends StatefulWidget {
  @override
  State<_NewPasswordConfirmInput> createState() =>
      _NewPasswordConfirmInputState();
}

class _NewPasswordConfirmInputState extends State<_NewPasswordConfirmInput> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
      buildWhen: (previous, current) =>
          form_helpers.shouldRerenderFormInputField(previous, current) ||
          previous.newPassword != current.newPassword ||
          previous.newPasswordConfirm != current.newPasswordConfirm,
      builder: (context, state) {
        debugPrint("'ChangePasswordForm - _NewPasswordConfirmInput' (re)built");
        if (_controller.text != state.newPasswordConfirm.value) {
          _controller.text = state.newPasswordConfirm.value;
        }
        return TextField(
          controller: _controller,
          onChanged: (passwordConfirm) =>
              BlocProvider.of<ChangePasswordBloc>(context).add(
                  ChangePasswordNewPasswordConfirmChanged(passwordConfirm)),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'confirm new password',
            errorText: state.isInitial
                ? null
                : state.newPassword.value != state.newPasswordConfirm.value
                    ? "passwords don't match"
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
    return BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
      buildWhen: (previous, current) =>
          form_helpers.shouldRerenderFormSubmitButton(previous, current),
      builder: (context, state) {
        debugPrint("'ChangePasswordForm - _SubmitButton' (re)built");
        return ElevatedButton(
          child: const Text('Save new password'),
          onPressed: state.invalid || state.isInProgress
              ? null
              : () {
                  BlocProvider.of<ChangePasswordBloc>(context)
                      .add(const ChangePasswordFormSubmitted());
                },
        );
      },
    );
  }
}
