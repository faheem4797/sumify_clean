import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sumify_clean/core/error/failure.dart';
import 'package:sumify_clean/core/usecase/usecase.dart';
import 'package:sumify_clean/features/profile/domain/usecases/logout_user.dart';
import 'package:sumify_clean/features/profile/presentation/blocs/logout_bloc/logout_bloc.dart';

class MockLogoutUser extends Mock implements LogoutUser {}

class FakeNoParams extends Fake implements NoParams {}

void main() {
  late LogoutBloc logoutBloc;
  late MockLogoutUser mockLogoutUser;
  setUp(() {
    mockLogoutUser = MockLogoutUser();
    logoutBloc = LogoutBloc(logoutUser: mockLogoutUser);
    registerFallbackValue(FakeNoParams());
  });
  tearDown(() {
    logoutBloc.close();
  });

  test(
    'should have [LogoutInitial] state when logout bloc is initialized ',
    () async {
      //assert
      expect(logoutBloc.state, LogoutInitial());
    },
  );

  group('UserLogoutEvent', () {
    const tSuccessMessage = 'Success';
    const tFailureMessage = 'Failure';
    blocTest<LogoutBloc, LogoutState>(
      'emits [LogoutLoading, LogoutSuccess] when UserLogoutEvent is added and LogoutUserUsecase returns a success string.',
      build: () => logoutBloc,
      setUp: () => when(() => mockLogoutUser(any()))
          .thenAnswer((_) async => const Right(tSuccessMessage)),
      act: (bloc) => bloc.add(UserLogoutEvent()),
      expect: () => <LogoutState>[
        LogoutLoading(),
        const LogoutSuccess(message: tSuccessMessage)
      ],
      verify: (_) {
        verify(() => mockLogoutUser(NoParams())).called(1);
      },
    );
    blocTest<LogoutBloc, LogoutState>(
      'emits [LogoutLoading, LogoutFailure] when UserLogoutEvent is added and LogoutUserUsecase returns a failure.',
      build: () => logoutBloc,
      setUp: () => when(() => mockLogoutUser(any()))
          .thenAnswer((_) async => const Left(Failure(tFailureMessage))),
      act: (bloc) => bloc.add(UserLogoutEvent()),
      expect: () => <LogoutState>[
        LogoutLoading(),
        const LogoutFailure(message: tFailureMessage)
      ],
    );
  });
}
