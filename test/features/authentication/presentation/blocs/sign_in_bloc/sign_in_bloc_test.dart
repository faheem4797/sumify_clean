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
  tearDown(() {
    signInBloc.close();
  });

  const String tValidEmail = 'test@example.com';
  const String tInvalidEmail = 'invalid-email';
  const String tValidPassword = '12345678';
  const String tInvalidPassword = '';

  test(
    'should emit correct initial state on initialization of bloc',
    () async {
      //assert
      expect(
          signInBloc.state,
          isA<SignInState>()
              .having((state) => state.email.isPure, 'email', true)
              .having((state) => state.password.isPure, 'password', true)
              .having((state) => state.status, 'status',
                  FormzSubmissionStatus.initial)
              .having((state) => state.isValid, 'isValid', false)
              .having(
                  (state) => state.passwordObscured, 'passwordObscured', true));
    },
  );

  group('SignInEmailChanged', () {
    blocTest<SignInBloc, SignInState>(
      'emits updated state with valid email when email is valid',
      build: () => signInBloc,
      act: (bloc) => bloc.add(const SignInEmailChanged(email: tValidEmail)),
      expect: () => const <SignInState>[
        SignInState(
          email: Email.dirty(tValidEmail),
        ),
      ],
    );
    blocTest<SignInBloc, SignInState>(
      'emits updated state with invalid email and isValid = false when email is invalid',
      build: () => signInBloc,
      act: (bloc) => bloc.add(const SignInEmailChanged(email: tInvalidEmail)),
      expect: () => const <SignInState>[
        SignInState(
          email: Email.dirty(tInvalidEmail),
          isValid: false,
        ),
      ],
    );
    blocTest<SignInBloc, SignInState>(
      'emits updated state with valid email but isValid = true when valid seed is provided',
      build: () => signInBloc,
      seed: () => const SignInState(password: Password.dirty(tValidPassword)),
      act: (bloc) => bloc.add(const SignInEmailChanged(email: tValidEmail)),
      expect: () => const <SignInState>[
        SignInState(
          email: Email.dirty(tValidEmail),
          password: Password.dirty(tValidPassword),
          isValid: true,
        ),
      ],
    );
  });

  group('SignInPasswordChanged', () {
    blocTest<SignInBloc, SignInState>(
      'emits updated state with valid password when SignInPasswordChanged is added',
      build: () => signInBloc,
      act: (bloc) =>
          bloc.add(const SignInPasswordChanged(password: tValidPassword)),
      expect: () => const <SignInState>[
        SignInState(
          password: Password.dirty(tValidPassword),
        ),
      ],
    );
    blocTest<SignInBloc, SignInState>(
      'emits updated state with invalid password and isValid as false when password is empty',
      build: () => signInBloc,
      act: (bloc) =>
          bloc.add(const SignInPasswordChanged(password: tInvalidPassword)),
      expect: () => const <SignInState>[
        SignInState(
          password: Password.dirty(tInvalidPassword),
          isValid: false,
        ),
      ],
    );
    blocTest<SignInBloc, SignInState>(
      'emits updated state with valid password and isValid = true when valid password is added valid seed is provided',
      build: () => signInBloc,
      seed: () => const SignInState(email: Email.dirty(tValidEmail)),
      act: (bloc) =>
          bloc.add(const SignInPasswordChanged(password: tValidPassword)),
      expect: () => const <SignInState>[
        SignInState(
          email: Email.dirty(tValidEmail),
          password: Password.dirty(tValidPassword),
          isValid: true,
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
        email: Email.dirty(tValidEmail),
        password: Password.dirty(tInvalidPassword),
        isValid:
            true, //Have to use isValid as true here because otherwise bloc will not consider it as a new state because both states are same
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
        email: Email.dirty(tInvalidEmail),
        password: Password.dirty(tValidPassword),
        isValid:
            true, //Have to use isValid as true here because otherwise bloc will not consider it as a new state because both states are same
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
