part of 'remove_account_bloc.dart';

enum RemoveAccountStateType {
  initial,
  removingAccount,
  removingAccountSuccess,
  removingAccountError,
}

class RemoveAccountState extends MyFormState {
  const RemoveAccountState({
    type = RemoveAccountStateType.initial,
    this.message = '',
  }) : super(type: type);

  final String message;

  @override
  bool get valid => true;
  @override
  bool get invalid => false;

  @override
  bool get isInitial => type == RemoveAccountStateType.initial;
  @override
  bool get isData => false;
  bool get isRegistrating => type == RemoveAccountStateType.removingAccount;
  bool get isRegistratingSuccess =>
      type == RemoveAccountStateType.removingAccountSuccess;
  bool get isRegistratingError =>
      type == RemoveAccountStateType.removingAccountError;

  @override
  bool get isInProgress => isInitial || isRegistrating;
  @override
  bool get isError => isRegistratingError;
  @override
  bool get isSuccess => isRegistratingSuccess;

  @override
  RemoveAccountState clear() {
    return const RemoveAccountState();
  }

  @override
  RemoveAccountState copyWith({
    RemoveAccountStateType? type,
    String? message,
  }) {
    return RemoveAccountState(
      type: type ?? this.type,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [type, message];
}
