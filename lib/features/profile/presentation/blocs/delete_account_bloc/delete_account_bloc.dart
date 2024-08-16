import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sumify_clean/core/domain/entities/app_user.dart';
import 'package:sumify_clean/features/profile/domain/usecases/delete_account.dart';

part 'delete_account_event.dart';
part 'delete_account_state.dart';

class DeleteAccountBloc extends Bloc<DeleteAccountEvent, DeleteAccountState> {
  final DeleteAccount _deleteAccount;
  DeleteAccountBloc({required DeleteAccount deleteAccount})
      : _deleteAccount = deleteAccount,
        super(DeleteAccountInitial()) {
    on<DeleteAccountEvent>((_, emit) => emit(DeleteAccountLoading()));
    on<DeleteUserAccountEvent>(_deleteUserAccountEvent);
  }

  FutureOr<void> _deleteUserAccountEvent(
      DeleteUserAccountEvent event, Emitter<DeleteAccountState> emit) async {
    final response = await _deleteAccount(DeleteAccountParams(
        email: event.email, password: event.password, appUser: event.appUser));
    response.fold(
      (l) => emit(DeleteAccountFailure(message: l.message)),
      (r) => emit(DeleteAccountSuccess(message: r)),
    );
  }
}
