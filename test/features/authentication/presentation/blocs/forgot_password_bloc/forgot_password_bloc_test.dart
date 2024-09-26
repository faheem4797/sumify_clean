import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:sumify_clean/core/common/form_inputs/email.dart';
import 'package:sumify_clean/features/authentication/presentation/blocs/forgot_password_bloc/forgot_password_bloc.dart';

void main() {
  late ForgotPasswordBloc forgotPasswordBloc;

  setUp(() {
    forgotPasswordBloc = ForgotPasswordBloc();
  });
  tearDown(() {
    forgotPasswordBloc.close();
  });

  const String tValidEmail = 'test@example.com';
  const String tInvalidEmail = 'invalid-email';

  test(
    'should return initial state when ForgotPasswordBloc is initialized',
    () async {
      //assert
      expect(
          forgotPasswordBloc.state,
          isA<ForgotPasswordState>()
              .having((state) => state.email.isPure, 'email', true)
              .having((state) => state.status, 'status',
                  FormzSubmissionStatus.initial)
              .having((state) => state.isValid, 'isValid', false));
    },
  );

  group('ForgotPasswordEmailChanged', () {
    blocTest<ForgotPasswordBloc, ForgotPasswordState>(
      'emits updated state with valid email and isValid = true when email is valid',
      build: () => forgotPasswordBloc,
      act: (bloc) =>
          bloc.add(const ForgotPasswordEmailChanged(email: tValidEmail)),
      expect: () => const <ForgotPasswordState>[
        ForgotPasswordState(
          email: Email.dirty(tValidEmail),
          isValid: true,
        ),
      ],
    );

    blocTest<ForgotPasswordBloc, ForgotPasswordState>(
      'emits updated state with invalid email and isValid = false when email is invalid',
      build: () => forgotPasswordBloc,
      act: (bloc) =>
          bloc.add(const ForgotPasswordEmailChanged(email: tInvalidEmail)),
      expect: () => <ForgotPasswordState>[
        const ForgotPasswordState(
          email: Email.dirty(tInvalidEmail),
          isValid: false,
        ),
      ],
    );
  });
  group('ForgotPasswordButtonPressed', () {
    blocTest<ForgotPasswordBloc, ForgotPasswordState>(
      'emits updated state with valid email and isValid = true when button is pressed',
      build: () => forgotPasswordBloc,
      seed: () => const ForgotPasswordState(
          email: Email.dirty(tValidEmail),
          status: FormzSubmissionStatus.initial,
          isValid: false),
      act: (bloc) =>
          bloc.add(const ForgotPasswordEmailChanged(email: tValidEmail)),
      expect: () => <ForgotPasswordState>[
        const ForgotPasswordState(
          email: Email.dirty(tValidEmail),
          isValid: true,
        ),
      ],
    );

    blocTest<ForgotPasswordBloc, ForgotPasswordState>(
      'emits updated state with invalid email and isValid = false when button is pressed',
      build: () => forgotPasswordBloc,
      seed: () => const ForgotPasswordState(
        email: Email.dirty(tValidEmail),
        status: FormzSubmissionStatus.initial,
        isValid: false,
      ),
      act: (bloc) =>
          bloc.add(const ForgotPasswordEmailChanged(email: tInvalidEmail)),
      expect: () => <ForgotPasswordState>[
        const ForgotPasswordState(
          email: Email.dirty(tInvalidEmail),
          isValid: false,
        ),
      ],
    );
  });
}
