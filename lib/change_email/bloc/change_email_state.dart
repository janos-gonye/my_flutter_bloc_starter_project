part of 'change_email_bloc.dart';

enum ChangeEmailStateType {
  initial,
  data,
  emailChanging,
  emailChangingSuccess,
  emailChangingError,
}

class ChangeEmailState extends MyFormState<ChangeEmailStateType> {
  const ChangeEmailState({
    this.email = const Email(''),
    this.emailConfirm = const Email(''),
    type = ChangeEmailStateType.initial,
    this.message = '',
  }) : super(type: type);

  final Email email;
  final Email emailConfirm;
  final String message;

  @override
  bool get valid => email.valid && emailConfirm.valid;
  @override
  bool get invalid => !valid;

  @override
  bool get isInitial => type == ChangeEmailStateType.initial;
  @override
  bool get isData => type == ChangeEmailStateType.data;
  bool get isEmailChanging => type == ChangeEmailStateType.emailChanging;
  bool get isEmailChangingSuccess =>
      type == ChangeEmailStateType.emailChangingSuccess;
  bool get isEmailChangingError =>
      type == ChangeEmailStateType.emailChangingError;

  @override
  bool get isInProgress => isInitial || isEmailChanging;
  @override
  bool get isError => isEmailChangingError;
  @override
  bool get isSuccess => isEmailChangingSuccess;

  @override
  ChangeEmailState clear() {
    return const ChangeEmailState();
  }

  @override
  ChangeEmailState copyWith({
    Email? email,
    Email? emailConfirm,
    ChangeEmailStateType? type,
    String? message,
  }) {
    return ChangeEmailState(
      email: email ?? this.email,
      emailConfirm: emailConfirm ?? this.emailConfirm,
      type: type ?? this.type,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [email, emailConfirm, type, message];
}
