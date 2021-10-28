import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:my_flutter_bloc_starter_project/login/login.dart';

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
      listenWhen: (previous, current) => previous.type != current.type,
      listener: (context, state) {
        debugPrint("'LoginForm' listener invoked");
        if (state.isLoggingInError) {
          EasyLoading.showError('Login Failure');
        } else if (state.isLoggingInSuccess) {
          EasyLoading.show(
              status: 'loading...', maskType: EasyLoadingMaskType.clear);
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
      buildWhen: (previous, current) => previous.username != current.username,
      builder: (context, state) {
        debugPrint("'LoginForm - _UsernameInput' (re)built");
        return TextField(
          onChanged: (username) => BlocProvider.of<LoginBloc>(context)
              .add(LoginUsernameChanged(username)),
          decoration: InputDecoration(
            labelText: 'username',
            errorText: state.username.errorMessage,
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        debugPrint("'LoginForm - _PasswordInput' (re)built");
        return TextField(
          onChanged: (password) => BlocProvider.of<LoginBloc>(context)
              .add(LoginPasswordChanged(password)),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'password',
            errorText: state.password.errorMessage,
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
          (previous.valid && current.invalid) ||
          (previous.invalid && current.valid) ||
          (previous.isInProgress && !current.isInProgress) ||
          (!previous.isInProgress && current.isInProgress),
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
