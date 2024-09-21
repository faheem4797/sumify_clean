import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sumify_clean/core/common/cubits/app_user_cubit.dart';
import 'package:sumify_clean/core/domain/entities/app_user.dart';

void main() {
  late AppUserCubit appUserCubit;

  setUp(() {
    appUserCubit = AppUserCubit();
  });
  tearDown(() => appUserCubit.close());

  group('AppUserCubit', () {
    const tUser = AppUser(id: '1', name: 'test', email: 'test@example.com');
    test('initial state is [AppUserLoading]', () {
      // Assert
      expect(appUserCubit.state, equals(AppUserLoading()));
    });

    blocTest<AppUserCubit, AppUserState>(
      'emits [AppUserInitial] when updateUser is called with null',
      build: () => appUserCubit,
      act: (cubit) => cubit.updateUser(null),
      expect: () => <AppUserState>[AppUserInitial()],
    );

    blocTest<AppUserCubit, AppUserState>(
      'emits [AppUserLoggedIn] when updateUser is called with a valid user',
      build: () => appUserCubit,
      act: (cubit) => cubit.updateUser(tUser),
      expect: () => [
        isA<AppUserLoggedIn>()
            .having((state) => state.user.id, 'user id', '1')
            .having((state) => state.user.name, 'name', 'test')
            .having((state) => state.user.email, 'email', 'test@example.com'),
      ],
    );
  });
}
