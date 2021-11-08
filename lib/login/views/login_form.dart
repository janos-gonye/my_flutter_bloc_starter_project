import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:my_flutter_bloc_starter_project/login/login.dart';
import 'package:my_flutter_bloc_starter_project/user/views/user_page.dart';

import 'package:my_flutter_bloc_starter_project/shared/views/helpers.dart'
    as helpers;
import 'package:my_flutter_bloc_starter_project/shared/views/forms/helpers.dart'
    as form_helpers;

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<LoginBloc>(context).add(const LoginFormInitialized());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listenWhen: (previous, current) =>
          form_helpers.shouldFormListen(previous, current),
      listener: (context, state) {
        debugPrint("'LoginForm' listener invoked");
        if (state.isLoggingInError) {
          EasyLoading.dismiss();
          helpers.showSnackbar(context, state.message);
        } else if (state.isLoggingIn) {
          EasyLoading.show(
              status: 'loading...', maskType: EasyLoadingMaskType.clear);
        } else if (state.isLoggingInSuccess) {
          EasyLoading.dismiss();
          Navigator.of(context).pushNamedAndRemoveUntil(
            UserPage.routeName,
            (route) => false,
          );
        } else {
          EasyLoading.dismiss();
        }
      },
      child: Column(
        children: [
          _UsernameInput(),
          _PasswordInput(),
          _SubmitButton(),
        ],
      ),
    );
  }
}

class _UsernameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) =>
          form_helpers.shouldRerenderFormInputField(previous, current) ||
          previous.username != current.username,
      builder: (context, state) {
        debugPrint("'LoginForm - _UsernameInput' (re)built");
        return TextField(
          onChanged: (username) => BlocProvider.of<LoginBloc>(context)
              .add(LoginUsernameChanged(username)),
          decoration: InputDecoration(
            labelText: 'username',
            errorText: state.isInitial ? null : state.username.errorMessage,
          ),
        );
      },
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
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) =>
          form_helpers.shouldRerenderFormInputField(previous, current) ||
          previous.password != current.password,
      builder: (context, state) {
        debugPrint("'LoginForm - _PasswordInput' (re)built");
        if (_controller.text != state.password.value) {
          _controller.text = state.password.value;
        }
        return TextField(
          controller: _controller,
          onChanged: (password) => BlocProvider.of<LoginBloc>(context)
              .add(LoginPasswordChanged(password)),
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

class _SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) =>
          form_helpers.shouldRerenderFormSubmitButton(previous, current),
      builder: (context, state) {
        debugPrint("'LoginForm - _SubmitButton' (re)built");
        return ElevatedButton(
          child: const Text('Login'),
          onPressed: state.invalid || state.isInProgress
              ? null
              : () {
                  BlocProvider.of<LoginBloc>(context)
                      .add(const LoginFormSubmitted());
                },
        );
      },
    );
  }
}
