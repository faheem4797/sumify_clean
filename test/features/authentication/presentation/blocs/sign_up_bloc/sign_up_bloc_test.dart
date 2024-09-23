import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:sumify_clean/core/common/form_inputs/confirm_password.dart';
import 'package:sumify_clean/core/common/form_inputs/email.dart';
import 'package:sumify_clean/core/common/form_inputs/full_name.dart';
import 'package:sumify_clean/core/common/form_inputs/password.dart';
import 'package:sumify_clean/features/authentication/presentation/blocs/sign_up_bloc/sign_up_bloc.dart';

void main() {
  late SignUpBloc signUpBloc;
  setUp(() {
    signUpBloc = SignUpBloc();
  });

  const String tValidName = 'test name';
  const String tInvalidName = '';
  const String tValidEmail = 'test@example.com';
  const String tInvalidEmail = 'invalid-email';
  const String tValidPassword = '12345678';
  const String tInvalidPassword = '';

  test(
    'should emit correct initial state on initialization of bloc',
    () async {
      //act
      const expectedState = SignUpState(
        fullName: FullName.pure(),
        email: Email.pure(),
        password: Password.pure(),
        confirmPassword: ConfirmPassword.pure(),
        status: FormzSubmissionStatus.initial,
        isValid: false,
        passwordObscured: true,
        confirmPasswordObscured: true,
      );

      //assert
      expect(signUpBloc.state, expectedState);
    },
  );

  group('SignInEmailChanged', () {
    blocTest<SignUpBloc, SignUpState>(
      'emits updated state with valid email and isValid = true when email is valid and password is valid',
      build: () => signUpBloc,
      seed: () => const SignUpState(password: Password.dirty(tValidPassword)),
      act: (bloc) => bloc.add(const SignUpEmailChanged(email: tValidEmail)),
      expect: () => const <SignUpState>[
        SignUpState(
          email: Email.dirty(tValidEmail),
          password: Password.dirty(tValidPassword),
          isValid: true,
          status: FormzSubmissionStatus.initial,
          passwordObscured: true,
        ),
      ],
    );
  });
}
