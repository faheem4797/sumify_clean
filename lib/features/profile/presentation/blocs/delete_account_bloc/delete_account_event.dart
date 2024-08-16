part of 'delete_account_bloc.dart';

sealed class DeleteAccountEvent extends Equatable {
  const DeleteAccountEvent();

  @override
  List<Object> get props => [];
}

final class DeleteUserAccountEvent extends DeleteAccountEvent {
  final String email;
  final String password;
  final AppUser appUser;

  const DeleteUserAccountEvent(
      {required this.email, required this.password, required this.appUser});

  @override
  List<Object> get props => [email, password, appUser];
}
