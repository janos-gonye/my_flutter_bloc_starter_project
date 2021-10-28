import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:my_flutter_bloc_starter_project/home/home.dart';
import 'package:my_flutter_bloc_starter_project/registration/registration.dart';

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
          !current.isData && previous.type != current.type,
      listener: (context, state) {
        debugPrint("'RegistrationForm' listener invoked");
        if (state.isRegistratingError) {
          EasyLoading.showError('Registration Failure');
        } else if (state.isInProgress) {
          EasyLoading.show(
            status: 'loading...',
            maskType: EasyLoadingMaskType.clear,
          );
        } else if (state.isRegistratingSuccess) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            HomePage.routeName,
            (route) => false,
          );
          EasyLoading.showSuccess("Confirmation email sent");
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
      buildWhen: (previous, current) => previous.username != current.username,
      builder: (context, state) {
        debugPrint("'RegistrationForm - _UsernameInput' (re)built");
        return TextField(
          onChanged: (username) => BlocProvider.of<RegistrationBloc>(context)
              .add(RegistrationUsernameChanged(username)),
          decoration: InputDecoration(
            labelText: 'username',
            errorText: state.username.errorMessage,
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
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        debugPrint("'RegistrationForm - _EmailInput' (re)built");
        return TextField(
          onChanged: (email) => BlocProvider.of<RegistrationBloc>(context)
              .add(RegistrationEmailChanged(email)),
          decoration: InputDecoration(
            labelText: 'email',
            errorText: state.email.errorMessage,
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
          previous.password != current.password ||
          previous.passwordConfirm != current.passwordConfirm,
      builder: (context, state) {
        debugPrint("'RegistrationForm - _PasswordInput' (re)built");
        return TextField(
          onChanged: (password) => BlocProvider.of<RegistrationBloc>(context)
              .add(RegistrationPasswordChanged(password)),
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

class _PasswordConfirmInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationBloc, RegistrationState>(
      buildWhen: (previous, current) =>
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
            labelText: 'password',
            errorText: state.password.value != state.passwordConfirm.value
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
          (previous.valid && current.invalid) ||
          (previous.invalid && current.valid) ||
          (previous.isInProgress && !current.isInProgress) ||
          (!previous.isInProgress && current.isInProgress),
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
