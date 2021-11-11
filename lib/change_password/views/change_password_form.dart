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
          _PasswordInput(),
          _PasswordConfirmInput(),
          _SubmitButton(),
        ],
      ),
    );
  }
}

class _PasswordInput extends StatefulWidget {
  @override
  State<_PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<_PasswordInput> {
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
          previous.password != current.password,
      builder: (context, state) {
        debugPrint("'ChangePasswordForm - _PasswordInput' (re)built");
        if (_controller.text != state.password.value) {
          _controller.text = state.password.value;
        }
        return TextField(
          controller: _controller,
          onChanged: (password) => BlocProvider.of<ChangePasswordBloc>(context)
              .add(ChangePasswordPasswordChanged(password)),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'password',
            errorText: state.isInitial ? null : state.password.errorMessage,
          ),
        );
      },
    );
  }
}

class _PasswordConfirmInput extends StatefulWidget {
  @override
  State<_PasswordConfirmInput> createState() => _PasswordConfirmInputState();
}

class _PasswordConfirmInputState extends State<_PasswordConfirmInput> {
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
          previous.password != current.password ||
          previous.passwordConfirm != current.passwordConfirm,
      builder: (context, state) {
        debugPrint("'ChangePasswordForm - _PasswordConfirmInput' (re)built");
        if (_controller.text != state.passwordConfirm.value) {
          _controller.text = state.passwordConfirm.value;
        }
        return TextField(
          controller: _controller,
          onChanged: (passwordConfirm) =>
              BlocProvider.of<ChangePasswordBloc>(context)
                  .add(ChangePasswordPasswordConfirmChanged(passwordConfirm)),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'confirm password',
            errorText: state.isInitial
                ? null
                : state.password.value != state.passwordConfirm.value
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
