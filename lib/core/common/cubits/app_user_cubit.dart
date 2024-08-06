import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sumify_clean/core/domain/entities/app_user.dart';

part 'app_user_state.dart';

class AppUserCubit extends Cubit<AppUserState> {
  AppUserCubit() : super(AppUserLoading());

  void updateUser(AppUser? user) {
    if (user == null) {
      emit(AppUserInitial());
    } else {
      emit(AppUserLoggedIn(user));
    }
  }
}
