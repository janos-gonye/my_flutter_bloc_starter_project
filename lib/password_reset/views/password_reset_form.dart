import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:my_flutter_bloc_starter_project/home/views/home_page.dart';
import 'package:my_flutter_bloc_starter_project/password_reset/password_reset.dart';
import 'package:my_flutter_bloc_starter_project/shared/helpers.dart' as helpers;

class PasswordResetForm extends StatefulWidget {
  const PasswordResetForm({Key? key}) : super(key: key);

  @override
  State<PasswordResetForm> createState() => _PasswordResetFormState();
}

class _PasswordResetFormState extends State<PasswordResetForm> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<PasswordResetBloc>(context)
        .add(const PasswordResetFormInitialized());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PasswordResetBloc, PasswordResetState>(
      listenWhen: (previous, current) =>
          helpers.shouldFormListen(previous, current),
      listener: (context, state) {
        debugPrint("'PasswordResetForm' listener invoked");
        if (state.isInProgress) {
          EasyLoading.show(
              status: 'loading...', maskType: EasyLoadingMaskType.clear);
        } else if (state.isPasswordResettingError) {
          EasyLoading.dismiss();
          helpers.showSnackbar(context, 'Sending email failed');
        } else if (state.isPasswordResettingSuccess) {
          EasyLoading.dismiss();
          helpers.showSnackbar(context, 'Confirmation email sent');
          Navigator.of(context).pushNamedAndRemoveUntil(
            HomePage.routeName,
            (route) => false,
          );
        } else {
          EasyLoading.dismiss();
        }
      },
      child: Column(
        children: [
          _EmailInput(),
          _SubmitButton(),
        ],
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PasswordResetBloc, PasswordResetState>(
      buildWhen: (previous, current) =>
          helpers.shouldRerenderFormInputField(previous, current) ||
          previous.email != current.email,
      builder: (context, state) {
        debugPrint("'PasswordResetForm - _EmailInput' (re)built");
        return TextField(
          onChanged: (email) => BlocProvider.of<PasswordResetBloc>(context)
              .add(PasswordResetEmailChanged(email)),
          decoration: InputDecoration(
            labelText: 'email',
            errorText: state.isInitial ? null : state.email.errorMessage,
          ),
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PasswordResetBloc, PasswordResetState>(
      buildWhen: (previous, current) =>
          helpers.shouldRerenderFormSubmitButton(previous, current),
      builder: (context, state) {
        debugPrint("'PasswordResetForm - _SubmitButton' (re)built");
        return ElevatedButton(
          child: const Text('Reset Password'),
          onPressed: state.invalid || state.isInProgress
              ? null
              : () {
                  BlocProvider.of<PasswordResetBloc>(context)
                      .add(const PasswordResetFormSubmitted());
                },
        );
      },
    );
  }
}
