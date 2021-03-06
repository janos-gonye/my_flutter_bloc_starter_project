import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:my_flutter_bloc_starter_project/home/home.dart';
import 'package:my_flutter_bloc_starter_project/registration/registration.dart';

import 'package:my_flutter_bloc_starter_project/shared/views/helpers.dart'
    as helpers;
import 'package:my_flutter_bloc_starter_project/shared/views/forms/helpers.dart'
    as form_helpers;

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({Key? key}) : super(key: key);

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<RegistrationBloc>(context)
        .add(const RegistrationFormInitialized());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegistrationBloc, RegistrationState>(
      listenWhen: (previous, current) =>
          form_helpers.shouldFormListen(previous, current),
      listener: (context, state) {
        debugPrint("'RegistrationForm' listener invoked");
        if (state.isRegistratingError) {
          EasyLoading.dismiss();
          helpers.showSnackbar(context, state.message);
        } else if (state.isRegistrating) {
          EasyLoading.show(
            status: 'loading...',
            maskType: EasyLoadingMaskType.clear,
          );
        } else if (state.isRegistratingSuccess) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            HomePage.routeName,
            (route) => false,
          );
          EasyLoading.dismiss();
          helpers.showSnackbar(context, state.message);
        } else {
          EasyLoading.dismiss();
        }
      },
      child: Column(
        children: [
          _UsernameInput(),
          _EmailInput(),
          _PasswordInput(),
          _PasswordConfirmInput(),
          _SubmitButton(),
        ],
      ),
    );
  }
}

class _UsernameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationBloc, RegistrationState>(
      buildWhen: (previous, current) =>
          form_helpers.shouldRerenderFormInputField(previous, current) ||
          previous.username != current.username,
      builder: (context, state) {
        debugPrint("'RegistrationForm - _UsernameInput' (re)built");
        return TextField(
          onChanged: (username) => BlocProvider.of<RegistrationBloc>(context)
              .add(RegistrationUsernameChanged(username)),
          decoration: InputDecoration(
            labelText: 'username',
            errorText: state.isInitial ? null : state.username.errorMessage,
          ),
        );
      },
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationBloc, RegistrationState>(
      buildWhen: (previous, current) =>
          form_helpers.shouldRerenderFormInputField(previous, current) ||
          previous.email != current.email,
      builder: (context, state) {
        debugPrint("'RegistrationForm - _EmailInput' (re)built");
        return TextField(
          onChanged: (email) => BlocProvider.of<RegistrationBloc>(context)
              .add(RegistrationEmailChanged(email)),
          decoration: InputDecoration(
            labelText: 'email',
            errorText: state.isInitial ? null : state.email.errorMessage,
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationBloc, RegistrationState>(
      buildWhen: (previous, current) =>
          form_helpers.shouldRerenderFormInputField(previous, current) ||
          previous.password != current.password,
      builder: (context, state) {
        debugPrint("'RegistrationForm - _PasswordInput' (re)built");
        return TextField(
          onChanged: (password) => BlocProvider.of<RegistrationBloc>(context)
              .add(RegistrationPasswordChanged(password)),
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

class _PasswordConfirmInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationBloc, RegistrationState>(
      buildWhen: (previous, current) =>
          form_helpers.shouldRerenderFormInputField(previous, current) ||
          previous.password != current.password ||
          previous.passwordConfirm != current.passwordConfirm,
      builder: (context, state) {
        debugPrint("'RegistrationForm - _PasswordConfirmInput' (re)built");
        return TextField(
          onChanged: (passwordConfirm) =>
              BlocProvider.of<RegistrationBloc>(context)
                  .add(RegistrationPasswordConfirmChanged(passwordConfirm)),
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
    return BlocBuilder<RegistrationBloc, RegistrationState>(
      buildWhen: (previous, current) =>
          form_helpers.shouldRerenderFormSubmitButton(previous, current),
      builder: (context, state) {
        debugPrint("'RegistrationForm - _SubmitButton' (re)built");
        return ElevatedButton(
          child: const Text('Registrate'),
          onPressed: state.invalid || state.isInProgress
              ? null
              : () {
                  BlocProvider.of<RegistrationBloc>(context)
                      .add(const RegistrationFormSubmitted());
                },
        );
      },
    );
  }
}
