import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sumify_clean/core/domain/entities/app_user.dart';
import 'package:sumify_clean/core/error/failure.dart';
import 'package:sumify_clean/core/usecase/usecase.dart';
import 'package:sumify_clean/features/authentication/domain/usecases/current_user.dart';
import 'package:sumify_clean/features/authentication/domain/usecases/forgot_password.dart';
import 'package:sumify_clean/features/authentication/domain/usecases/login_user.dart';
import 'package:sumify_clean/features/authentication/domain/usecases/signup_user.dart';
import 'package:sumify_clean/features/authentication/presentation/blocs/auth_bloc/auth_bloc.dart';

class MockSignUpUser extends Mock implements SignupUser {}

class MockLoginUser extends Mock implements LoginUser {}

class MockForgotPassword extends Mock implements ForgotPassword {}

class MockCurrentUser extends Mock implements CurrentUser {}

class FakeNoParams extends Fake implements NoParams {}

class FakeSignupUserParams extends Fake implements SignupUserParams {}

class FakeLoginUserParams extends Fake implements LoginUserParams {}

class FakeForgotPasswordParams extends Fake implements ForgotPasswordParams {}

void main() {
  late AuthBloc authBloc;
  late MockSignUpUser mockSignUpUser;
  late MockLoginUser mockLoginUser;
  late MockForgotPassword mockForgotPassword;
  late MockCurrentUser mockCurrentUser;

  setUp(() {
    mockSignUpUser = MockSignUpUser();
    mockLoginUser = MockLoginUser();
    mockForgotPassword = MockForgotPassword();
    mockCurrentUser = MockCurrentUser();
    authBloc = AuthBloc(
      signupUser: mockSignUpUser,
      loginUser: mockLoginUser,
      forgotPassword: mockForgotPassword,
      currentUser: mockCurrentUser,
    );

    registerFallbackValue(FakeNoParams());
    registerFallbackValue(FakeSignupUserParams());
    registerFallbackValue(FakeLoginUserParams());
    registerFallbackValue(FakeForgotPasswordParams());
  });

  const String tId = '123';
  const String tName = 'test user';
  const String tEmail = 'test@example.com';
  const String tPassword = '12345678';
  const String tFailureMessage = 'Error!';
  const AppUser tAppUser = AppUser(id: tId, name: tName, email: tEmail);

  test(
    'should have [AuthInitial(null)] state when authBloc is initialized',
    () async {
      //assert
      expect(authBloc.state, AuthInitial(null));
    },
  );

  group('AuthSignUp', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthSuccess] when SignUpUser usecase returns app user.',
      setUp: () => when(() => mockSignUpUser(any()))
          .thenAnswer((_) async => const Right(tAppUser)),
      build: () => authBloc,
      act: (bloc) =>
          bloc.add(AuthSignUp(name: tName, email: tEmail, password: tPassword)),
      expect: () => <AuthState>[AuthLoading(), AuthSuccess(tAppUser)],
      verify: (_) {
        verify(() => mockSignUpUser(const SignupUserParams(
            name: tName, email: tEmail, password: tPassword))).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthFailure] when SignUpUser usecase returns Failure.',
      setUp: () => when(() => mockSignUpUser(any()))
          .thenAnswer((_) async => const Left(Failure(tFailureMessage))),
      build: () => authBloc,
      act: (bloc) =>
          bloc.add(AuthSignUp(name: tName, email: tEmail, password: tPassword)),
      expect: () => <AuthState>[AuthLoading(), AuthFailure(tFailureMessage)],
      verify: (_) {
        verify(() => mockSignUpUser(const SignupUserParams(
            name: tName, email: tEmail, password: tPassword))).called(1);
      },
    );
  });
  group('AuthLogin', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthSuccess] when LoginUser usecase returns app user.',
      setUp: () => when(() => mockLoginUser(any()))
          .thenAnswer((_) async => const Right(tAppUser)),
      build: () => authBloc,
      act: (bloc) => bloc.add(AuthLogin(email: tEmail, password: tPassword)),
      expect: () => <AuthState>[AuthLoading(), AuthSuccess(tAppUser)],
      verify: (_) {
        verify(() => mockLoginUser(
                const LoginUserParams(email: tEmail, password: tPassword)))
            .called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthFailure] when LoginUser usecase returns Failure.',
      setUp: () => when(() => mockLoginUser(any()))
          .thenAnswer((_) async => const Left(Failure(tFailureMessage))),
      build: () => authBloc,
      act: (bloc) => bloc.add(AuthLogin(email: tEmail, password: tPassword)),
      expect: () => <AuthState>[AuthLoading(), AuthFailure(tFailureMessage)],
      verify: (_) {
        verify(() => mockLoginUser(
                const LoginUserParams(email: tEmail, password: tPassword)))
            .called(1);
      },
    );
  });
}
