import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:my_flutter_bloc_starter_project/authentication/authentication.dart';
import 'package:my_flutter_bloc_starter_project/remove_account/remove_account.dart';

import 'package:my_flutter_bloc_starter_project/shared/views/helpers.dart'
    as helpers;
import 'package:my_flutter_bloc_starter_project/shared/views/forms/helpers.dart'
    as form_helpers;

class RemoveAccountForm extends StatefulWidget {
  const RemoveAccountForm({Key? key}) : super(key: key);

  @override
  State<RemoveAccountForm> createState() => _RemoveAccountFormState();
}

class _RemoveAccountFormState extends State<RemoveAccountForm> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<RemoveAccountBloc>(context)
        .add(const RemoveAccountFormInitialized());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RemoveAccountBloc, RemoveAccountState>(
      listenWhen: (previous, current) =>
          form_helpers.shouldFormListen(previous, current),
      listener: (context, state) {
        debugPrint("'RemoveAccountForm' listener invoked");
        if (state.isRegistratingError) {
          EasyLoading.dismiss();
          helpers.showSnackbar(context, state.message);
        } else if (state.isRegistrating) {
          EasyLoading.show(
            status: 'loading...',
            maskType: EasyLoadingMaskType.clear,
          );
        } else if (state.isRegistratingSuccess) {
          EasyLoading.dismiss();
          helpers.showSnackbar(context, state.message);
          BlocProvider.of<AuthenticationBloc>(context)
              .add(AccountRemovalRequested());
        } else {
          EasyLoading.dismiss();
        }
      },
      child: _SubmitButton(),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RemoveAccountBloc, RemoveAccountState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        debugPrint("'RemoveAccountForm - _SubmitButton' (re)built");
        return OutlinedButton(
          child: const Text('Remove Account & Erase All Data'),
          onPressed: state.invalid || state.isRegistrating
              ? null
              : () async {
                  if (await confirm(
                    context,
                    title: const Text('Remove Account'),
                    content: const Text('Are you sure?'),
                  )) {
                    BlocProvider.of<RemoveAccountBloc>(context)
                        .add(const RemoveAccountFormSubmitted());
                  }
                },
        );
      },
    );
  }
}
