import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sumify_clean/core/usecase/usecase.dart';
import 'package:sumify_clean/features/profile/domain/usecases/logout_user.dart';

part 'logout_event.dart';
part 'logout_state.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final LogoutUser _logoutUser;
  LogoutBloc({required LogoutUser logoutUser})
      : _logoutUser = logoutUser,
        super(LogoutInitial()) {
    on<LogoutEvent>((_, emit) => emit(LogoutLoading()));
    on<UserLogoutEvent>(_userLogoutEvent);
  }

  FutureOr<void> _userLogoutEvent(
      UserLogoutEvent event, Emitter<LogoutState> emit) async {
    final response = await _logoutUser(NoParams());
    response.fold((l) => emit(LogoutFailure(message: l.message)),
        (r) => emit(LogoutSuccess(message: r)));
  }
}
