part of 'app_user_cubit.dart';

@immutable
sealed class AppUserState extends Equatable {}

final class AppUserInitial extends AppUserState {
  @override
  List<Object?> get props => [];
}

final class AppUserLoading extends AppUserState {
  @override
  List<Object?> get props => [];
}

final class AppUserLoggedIn extends AppUserState {
  final AppUser user;
  AppUserLoggedIn(this.user);

  @override
  List<Object?> get props => [user];
}
