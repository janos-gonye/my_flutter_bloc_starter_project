import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:my_flutter_bloc_starter_project/shared/bloc/states/base.dart';

void showSnackbar(BuildContext context, String text,
    {bool removeCurrent = true}) {
  final scaffoldMessenger = ScaffoldMessenger.of(context);
  if (removeCurrent) scaffoldMessenger.removeCurrentSnackBar();
  scaffoldMessenger.showSnackBar(SnackBar(content: Text(text)));
}

bool shouldRerenderFormSubmitButton(
  MyFormState previous,
  MyFormState current,
) {
  return (previous.invalid && current.valid) ||
      (previous.valid && current.invalid) ||
      (previous.isInProgress && !current.isInProgress) ||
      (!previous.isInProgress && current.isInProgress);
}

bool shouldRerenderFormInputField(
  MyFormState previous,
  MyFormState current,
) {
  return ((previous.isInitial && !current.isInitial) ||
      (!previous.isInitial && current.isInitial));
}

bool shouldFormListen(
  MyFormState previous,
  MyFormState current,
) {
  return !current.isData && previous.type != current.type;
}
