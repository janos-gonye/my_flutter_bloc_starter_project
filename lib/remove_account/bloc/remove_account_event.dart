part of 'remove_account_bloc.dart';

abstract class RemoveAccountEvent extends Equatable {
  const RemoveAccountEvent();

  @override
  List<Object> get props => [];
}

class RemoveAccountFormInitialized extends RemoveAccountEvent {
  const RemoveAccountFormInitialized();
}

class RemoveAccountFormSubmitted extends RemoveAccountEvent {
  const RemoveAccountFormSubmitted();
}
