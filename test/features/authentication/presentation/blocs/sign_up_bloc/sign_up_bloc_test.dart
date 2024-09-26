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

  tearDown(() {
    signUpBloc.close();
  });

  const String tValidFullName = 'test name';
  const String tInvalidFullName = '';
  const String tValidEmail = 'test@example.com';
  const String tInvalidEmail = 'invalid-email';
  const String tValidPassword = '12345678';
  const String tInvalidPassword = '';

  test(
    'should emit correct initial state on initialization of bloc',
    () async {
      //assert
      expect(
          signUpBloc.state,
          isA<SignUpState>()
              .having((state) => state.fullName.isPure, 'fullname', true)
              .having((state) => state.password.isPure, 'password', true)
              .having((state) => state.confirmPassword.isPure,
                  'confirmPassword', true)
              .having((state) => state.status, 'status',
                  FormzSubmissionStatus.initial)
              .having((state) => state.isValid, 'isValid', false)
              .having(
                  (state) => state.passwordObscured, 'passwordObscured', true)
              .having((state) => state.confirmPasswordObscured,
                  'confirmPasswordObscured', true));
    },
  );

  group('SignUpFullNameChanged', () {
    blocTest<SignUpBloc, SignUpState>(
      'emits new state with valid fullName when SignUpFullNameChanged is added',
      build: () => signUpBloc,
      act: (bloc) =>
          bloc.add(const SignUpFullNameChanged(fullName: tValidFullName)),
      expect: () => [
        const SignUpState(
          fullName: FullName.dirty(tValidFullName),
        ),
      ],
    );

    blocTest<SignUpBloc, SignUpState>(
      'emits new state with invalid fullName and isValid as false when empty fullName is added',
      build: () => signUpBloc,
      act: (bloc) =>
          bloc.add(const SignUpFullNameChanged(fullName: tInvalidFullName)),
      expect: () => [
        const SignUpState(
          fullName: FullName.dirty(tInvalidFullName),
          isValid: false,
        ),
      ],
    );

    blocTest<SignUpBloc, SignUpState>(
      'emits new state with valid fullName and isValid = true when valid fullName is added and valid seed is given',
      build: () => signUpBloc,
      seed: () => const SignUpState(
        email: Email.dirty(tValidEmail),
        password: Password.dirty(tValidPassword),
        confirmPassword: ConfirmPassword.dirty(
            password: tValidPassword, value: tValidPassword),
      ),
      act: (bloc) =>
          bloc.add(const SignUpFullNameChanged(fullName: tValidFullName)),
      expect: () => [
        const SignUpState(
            fullName: FullName.dirty(tValidFullName),
            email: Email.dirty(tValidEmail),
            password: Password.dirty(tValidPassword),
            confirmPassword: ConfirmPassword.dirty(
                password: tValidPassword, value: tValidPassword),
            isValid: true),
      ],
    );
  });
  group('SignUpEmailChanged', () {
    blocTest<SignUpBloc, SignUpState>(
      'emits new state with valid email when SignUpEmailChanged is added',
      build: () => signUpBloc,
      act: (bloc) => bloc.add(const SignUpEmailChanged(email: tValidEmail)),
      expect: () => [
        const SignUpState(
          email: Email.dirty(tValidEmail),
        ),
      ],
    );

    blocTest<SignUpBloc, SignUpState>(
      'emits new state with invalid email and isValid as false when empty email is added',
      build: () => signUpBloc,
      act: (bloc) => bloc.add(const SignUpEmailChanged(email: tInvalidEmail)),
      expect: () => [
        const SignUpState(
          email: Email.dirty(tInvalidEmail),
          isValid: false,
        ),
      ],
    );

    blocTest<SignUpBloc, SignUpState>(
      'emits new state with valid email and isValid = true when valid email is added and valid seed is given',
      build: () => signUpBloc,
      seed: () => const SignUpState(
        fullName: FullName.dirty(tValidFullName),
        password: Password.dirty(tValidPassword),
        confirmPassword: ConfirmPassword.dirty(
            password: tValidPassword, value: tValidPassword),
      ),
      act: (bloc) => bloc.add(const SignUpEmailChanged(email: tValidEmail)),
      expect: () => [
        const SignUpState(
          fullName: FullName.dirty(tValidFullName),
          email: Email.dirty(tValidEmail),
          password: Password.dirty(tValidPassword),
          confirmPassword: ConfirmPassword.dirty(
              password: tValidPassword, value: tValidPassword),
          isValid: true,
        ),
      ],
    );
  });

  group('SignUpPasswordChanged', () {
    blocTest<SignUpBloc, SignUpState>(
      'emits new state with valid password when SignUpPasswordChanged is added',
      build: () => signUpBloc,
      act: (bloc) =>
          bloc.add(const SignUpPasswordChanged(password: tValidPassword)),
      expect: () => [
        const SignUpState(
          password: Password.dirty(tValidPassword),
        ),
      ],
    );

    blocTest<SignUpBloc, SignUpState>(
      'emits new state with  confirmPassword and isValid as false when empty password is added',
      build: () => signUpBloc,
      act: (bloc) =>
          bloc.add(const SignUpPasswordChanged(password: tInvalidPassword)),
      expect: () => [
        const SignUpState(
          password: Password.dirty(tInvalidPassword),
          isValid: false,
        ),
      ],
    );

    blocTest<SignUpBloc, SignUpState>(
      'emits new state with valid password and isValid = true when valid password is added and valid seed is given',
      build: () => signUpBloc,
      seed: () => const SignUpState(
        fullName: FullName.dirty(tValidFullName),
        email: Email.dirty(tValidEmail),
        confirmPassword: ConfirmPassword.dirty(
            password: tValidPassword, value: tValidPassword),
      ),
      act: (bloc) =>
          bloc.add(const SignUpPasswordChanged(password: tValidPassword)),
      expect: () => [
        const SignUpState(
          fullName: FullName.dirty(tValidFullName),
          email: Email.dirty(tValidEmail),
          password: Password.dirty(tValidPassword),
          confirmPassword: ConfirmPassword.dirty(
              password: tValidPassword, value: tValidPassword),
          isValid: true,
        ),
      ],
    );
  });

  group('SignUpConfirmPasswordChanged', () {
    blocTest<SignUpBloc, SignUpState>(
      'emits new state with invalid confirmPassword when SignUpConfirmPasswordChanged is added',
      build: () => signUpBloc,
      act: (bloc) => bloc.add(
          const SignUpConfirmPasswordChanged(confirmPassword: tValidPassword)),
      expect: () => [
        const SignUpState(
          confirmPassword: ConfirmPassword.dirty(
              password: tInvalidPassword, value: tValidPassword),
        ),
      ],
    );

    blocTest<SignUpBloc, SignUpState>(
      'emits new state with invalid password and isValid as false when empty password is added',
      build: () => signUpBloc,
      seed: () => const SignUpState(password: Password.dirty(tValidPassword)),
      act: (bloc) => bloc.add(const SignUpConfirmPasswordChanged(
          confirmPassword: tInvalidPassword)),
      expect: () => [
        const SignUpState(
          password: Password.dirty(tValidPassword),
          confirmPassword: ConfirmPassword.dirty(
              password: tValidPassword, value: tInvalidPassword),
          isValid: false,
        ),
      ],
    );

    blocTest<SignUpBloc, SignUpState>(
      'emits new state with valid confirmPassword and isValid = true when valid confirmPassword is added and valid seed is given',
      build: () => signUpBloc,
      seed: () => const SignUpState(
        fullName: FullName.dirty(tValidFullName),
        email: Email.dirty(tValidEmail),
        password: Password.dirty(tValidPassword),
      ),
      act: (bloc) => bloc.add(
          const SignUpConfirmPasswordChanged(confirmPassword: tValidPassword)),
      expect: () => [
        const SignUpState(
          fullName: FullName.dirty(tValidFullName),
          email: Email.dirty(tValidEmail),
          password: Password.dirty(tValidPassword),
          confirmPassword: ConfirmPassword.dirty(
              password: tValidPassword, value: tValidPassword),
          isValid: true,
        ),
      ],
    );
  });

  group('SignUpPasswordObscurePressed', () {
    blocTest<SignUpBloc, SignUpState>(
      'emits updated state when SignUpPasswordObscurePressed is added with passwordObscured as false when seed provides passwordObascured as true.',
      build: () => signUpBloc,
      seed: () => const SignUpState(passwordObscured: true),
      act: (bloc) => bloc.add(SignUpPasswordObscurePressed()),
      expect: () => const <SignUpState>[
        SignUpState(
          passwordObscured: false,
        )
      ],
    );
    blocTest<SignUpBloc, SignUpState>(
      'emits updated state when SignUpPasswordObscurePressed is added with passwordObscured as true when seed provides passwordObascured as false.',
      build: () => signUpBloc,
      seed: () => const SignUpState(passwordObscured: false),
      act: (bloc) => bloc.add(SignUpPasswordObscurePressed()),
      expect: () => const <SignUpState>[
        SignUpState(
          passwordObscured: true,
        )
      ],
    );
  });
  group('SignUpConfirmPasswordObscurePressed', () {
    blocTest<SignUpBloc, SignUpState>(
      'emits updated state when SignUpConfirmPasswordObscurePressed is added with confirmPasswordObscured as false when seed provides passwordObascured as true.',
      build: () => signUpBloc,
      seed: () => const SignUpState(confirmPasswordObscured: true),
      act: (bloc) => bloc.add(SignUpConfirmPasswordObscurePressed()),
      expect: () => const <SignUpState>[
        SignUpState(
          confirmPasswordObscured: false,
        )
      ],
    );
    blocTest<SignUpBloc, SignUpState>(
      'emits updated state when SignUpConfirmPasswordObscurePressed is added with confirmPasswordObscured as true when seed provides passwordObascured as false.',
      build: () => signUpBloc,
      seed: () => const SignUpState(confirmPasswordObscured: false),
      act: (bloc) => bloc.add(SignUpConfirmPasswordObscurePressed()),
      expect: () => const <SignUpState>[
        SignUpState(
          confirmPasswordObscured: true,
        )
      ],
    );
  });

  group('SignUpButtonPressed', () {
    blocTest<SignUpBloc, SignUpState>(
      'emits new state with valid fields when SignUpButtonPressed is added',
      build: () => signUpBloc,
      seed: () => const SignUpState(
        fullName: FullName.dirty(tValidFullName),
        email: Email.dirty(tValidEmail),
        password: Password.dirty(tValidPassword),
        confirmPassword: ConfirmPassword.dirty(
            password: tValidPassword, value: tValidPassword),
        isValid: false,
      ),
      act: (bloc) => bloc.add(SignUpButtonPressed()),
      expect: () => [
        const SignUpState(
          fullName: FullName.dirty(tValidFullName),
          email: Email.dirty(tValidEmail),
          password: Password.dirty(tValidPassword),
          confirmPassword: ConfirmPassword.dirty(
              password: tValidPassword, value: tValidPassword),
          isValid: true,
        ),
      ],
    );
    blocTest<SignUpBloc, SignUpState>(
      'emits new state with invalid fields when any field is invalid',
      build: () => signUpBloc,
      seed: () => const SignUpState(
        fullName: FullName.dirty(tInvalidFullName),
        email: Email.dirty(tInvalidEmail),
        password: Password.dirty(tInvalidPassword),
        confirmPassword: ConfirmPassword.dirty(
            password: tInvalidPassword, value: tValidPassword),
        isValid: true,
      ),
      act: (bloc) => bloc.add(SignUpButtonPressed()),
      expect: () => [
        const SignUpState(
          fullName: FullName.dirty(tInvalidFullName),
          email: Email.dirty(tInvalidEmail),
          password: Password.dirty(tInvalidPassword),
          confirmPassword: ConfirmPassword.dirty(
              password: tInvalidPassword, value: tValidPassword),
          isValid: false,
        ),
      ],
    );
  });
}
