import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:sumify_clean/core/common/form_inputs/email.dart';
import 'package:sumify_clean/core/common/form_inputs/password.dart';
import 'package:sumify_clean/features/authentication/presentation/blocs/sign_in_bloc/sign_in_bloc.dart';

void main() {
  late SignInBloc signInBloc;

  setUp(() {
    signInBloc = SignInBloc();
  });

  const String tValidEmail = 'test@example.com';
  const String tInvalidEmail = 'invalid-email';
  const String tValidPassword = '12345678';
  const String tInvalidPassword = '';

  test(
    'should emit correct initial state on initialization of bloc',
    () async {
      //act
      const expectedState = SignInState(
        email: Email.pure(),
        password: Password.pure(),
        status: FormzSubmissionStatus.initial,
        isValid: false,
        passwordObscured: true,
      );

      //assert

      expect(signInBloc.state, expectedState);
    },
  );

  group('SignInEmailChanged', () {
    blocTest<SignInBloc, SignInState>(
      'emits updated state with valid email and isValid = true when email is valid and password is valid',
      build: () => signInBloc,
      seed: () => const SignInState(password: Password.dirty(tValidPassword)),
      act: (bloc) => bloc.add(const SignInEmailChanged(email: tValidEmail)),
      expect: () => const <SignInState>[
        SignInState(
          email: Email.dirty(tValidEmail),
          password: Password.dirty(tValidPassword),
          isValid: true,
          status: FormzSubmissionStatus.initial,
          passwordObscured: true,
        ),
      ],
    );
    blocTest<SignInBloc, SignInState>(
      'emits updated state with invalid email and isValid = false when email is invalid',
      build: () => signInBloc,
      seed: () => const SignInState(password: Password.dirty(tValidPassword)),
      act: (bloc) => bloc.add(const SignInEmailChanged(email: tInvalidEmail)),
      expect: () => const <SignInState>[
        SignInState(
          email: Email.dirty(tInvalidEmail),
          password: Password.dirty(tValidPassword),
          isValid: false,
          status: FormzSubmissionStatus.initial,
          passwordObscured: true,
        ),
      ],
    );
    blocTest<SignInBloc, SignInState>(
      'emits updated state with valid email but isValid = false when password is invalid',
      build: () => signInBloc,
      seed: () => const SignInState(password: Password.dirty(tInvalidPassword)),
      act: (bloc) => bloc.add(const SignInEmailChanged(email: tValidEmail)),
      expect: () => const <SignInState>[
        SignInState(
          email: Email.dirty(tValidEmail),
          password: Password.dirty(tInvalidPassword),
          isValid: false,
          status: FormzSubmissionStatus.initial,
          passwordObscured: true,
        ),
      ],
    );
  });

  group('SignInPasswordChanged', () {
    blocTest<SignInBloc, SignInState>(
      'emits updated state with valid password and isValid = true when password and email is valid',
      build: () => signInBloc,
      seed: () => const SignInState(email: Email.dirty(tValidEmail)),
      act: (bloc) =>
          bloc.add(const SignInPasswordChanged(password: tValidPassword)),
      expect: () => const <SignInState>[
        SignInState(
          email: Email.dirty(tValidEmail),
          password: Password.dirty(tValidPassword),
          isValid: true,
          status: FormzSubmissionStatus.initial,
          passwordObscured: true,
        ),
      ],
    );
    blocTest<SignInBloc, SignInState>(
      'emits updated state with invalid password and isValid = false when password is invalid',
      build: () => signInBloc,
      seed: () => const SignInState(email: Email.dirty(tValidEmail)),
      act: (bloc) =>
          bloc.add(const SignInPasswordChanged(password: tInvalidPassword)),
      expect: () => const <SignInState>[
        SignInState(
          email: Email.dirty(tValidEmail),
          password: Password.dirty(tInvalidPassword),
          isValid: false,
          status: FormzSubmissionStatus.initial,
          passwordObscured: true,
        ),
      ],
    );
    blocTest<SignInBloc, SignInState>(
      'emits updated state with valid password but isValid = false when email is invalid',
      build: () => signInBloc,
      seed: () => const SignInState(email: Email.dirty(tInvalidEmail)),
      act: (bloc) =>
          bloc.add(const SignInPasswordChanged(password: tValidPassword)),
      expect: () => const <SignInState>[
        SignInState(
          email: Email.dirty(tInvalidEmail),
          password: Password.dirty(tValidPassword),
          isValid: false,
          status: FormzSubmissionStatus.initial,
          passwordObscured: true,
        ),
      ],
    );
  });

  group('SignInPasswordObscurePressed', () {
    blocTest<SignInBloc, SignInState>(
      'emits updated state when SignInPasswordObscurePressed is added with passwordObscured as false when seed provides passwordObascured as true.',
      build: () => signInBloc,
      seed: () => const SignInState(passwordObscured: true),
      act: (bloc) => bloc.add(SignInPasswordObscurePressed()),
      expect: () => const <SignInState>[
        SignInState(
          email: Email.pure(),
          password: Password.pure(),
          isValid: false,
          status: FormzSubmissionStatus.initial,
          passwordObscured: false,
        )
      ],
    );
    blocTest<SignInBloc, SignInState>(
      'emits updated state when SignInPasswordObscurePressed is added with passwordObscured as true when seed provides passwordObascured as false.',
      build: () => signInBloc,
      seed: () => const SignInState(passwordObscured: false),
      act: (bloc) => bloc.add(SignInPasswordObscurePressed()),
      expect: () => const <SignInState>[
        SignInState(
          email: Email.pure(),
          password: Password.pure(),
          isValid: false,
          status: FormzSubmissionStatus.initial,
          passwordObscured: true,
        )
      ],
    );
  });

  group('SignInButtonPressed', () {
    blocTest<SignInBloc, SignInState>(
      'emits updated state with valid email & valid password and isValid = true when button is pressed',
      build: () => signInBloc,
      seed: () => const SignInState(
        email: Email.dirty(tValidEmail),
        password: Password.dirty(tValidPassword),
      ),
      act: (bloc) => bloc.add(SignInButtonPressed()),
      expect: () => const <SignInState>[
        SignInState(
          email: Email.dirty(tValidEmail),
          password: Password.dirty(tValidPassword),
          isValid: true,
        )
      ],
    );

    blocTest<SignInBloc, SignInState>(
      'emits updated state with valid email & invalid password and isValid = false when button is pressed',
      build: () => signInBloc,
      seed: () => const SignInState(
        //Have to use pure fields here because otherwise bloc will not consider it as a new state because both states are same
        email: Email.pure(tValidEmail),
        password: Password.pure(tInvalidPassword),
      ),
      act: (bloc) => bloc.add(SignInButtonPressed()),
      expect: () => const <SignInState>[
        SignInState(
          email: Email.dirty(tValidEmail),
          password: Password.dirty(tInvalidPassword),
          isValid: false,
        )
      ],
    );
    blocTest<SignInBloc, SignInState>(
      'emits updated state with invalid email & valid password and isValid = false when button is pressed',
      build: () => signInBloc,
      seed: () => const SignInState(
        //Have to use pure fields here because otherwise bloc will not consider it as a new state because both states are same
        email: Email.pure(tInvalidEmail),
        password: Password.pure(tValidPassword),
      ),
      act: (bloc) => bloc.add(SignInButtonPressed()),
      expect: () => const <SignInState>[
        SignInState(
          email: Email.dirty(tInvalidEmail),
          password: Password.dirty(tValidPassword),
          isValid: false,
        )
      ],
    );
  });
}
