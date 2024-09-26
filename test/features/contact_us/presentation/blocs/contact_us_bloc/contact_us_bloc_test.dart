import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sumify_clean/core/common/form_inputs/email.dart';
import 'package:sumify_clean/core/common/form_inputs/full_name.dart';
import 'package:sumify_clean/core/error/failure.dart';
import 'package:sumify_clean/features/contact_us/domain/usecases/send_email.dart';
import 'package:sumify_clean/features/contact_us/presentation/blocs/contact_us_bloc/contact_us_bloc.dart';

class MockSendEmail extends Mock implements SendEmail {}

class FakeSendEmailParams extends Fake implements SendEmailParams {}

void main() {
  late ContactUsBloc contactUsBloc;
  late MockSendEmail mockSendEmail;

  setUp(() {
    mockSendEmail = MockSendEmail();
    contactUsBloc = ContactUsBloc(sendEmail: mockSendEmail);

    registerFallbackValue(FakeSendEmailParams());
  });
  tearDown(() {
    contactUsBloc.close();
  });

  const String tSuccessString = 'Success';
  const String tValidEmail = 'test@example.com';
  const String tInvalidEmail = 'invalid-email';
  const String tValidFirstName = 'first';
  const String tInvalidFirstName = '';
  const String tValidLastName = 'last';
  const String tInvalidLastName = '';
  const String tValidMessage = 'message';
  const String tInValidMessage = '';

  test(
    'should emit correct initial state on initialization of bloc',
    () async {
      //assert
      expect(
          contactUsBloc.state,
          isA<ContactUsState>()
              .having((state) => state.firstName.isPure, 'firstName', true)
              .having((state) => state.lastName.isPure, 'lastName', true)
              .having((state) => state.email.isPure, 'email', true)
              .having((state) => state.message.isPure, 'message', true)
              .having((state) => state.status, 'status',
                  FormzSubmissionStatus.initial)
              .having((state) => state.isValid, 'isValid', false)
              .having((state) => state.errorMessage, 'errorMessage', null));
    },
  );

  group('ContactUsFirstNameChanged', () {
    blocTest<ContactUsBloc, ContactUsState>(
      'emits updated state with valid firstName when firstName is valid',
      build: () => contactUsBloc,
      act: (bloc) =>
          bloc.add(const ContactUsFirstNameChanged(firstName: tValidFirstName)),
      expect: () => const <ContactUsState>[
        ContactUsState(
          firstName: FullName.dirty(tValidFirstName),
        ),
      ],
    );
    blocTest<ContactUsBloc, ContactUsState>(
      'emits updated state with invalid firstName and isValid = false when firstName is invalid',
      build: () => contactUsBloc,
      act: (bloc) => bloc
          .add(const ContactUsFirstNameChanged(firstName: tInvalidFirstName)),
      expect: () => const <ContactUsState>[
        ContactUsState(
          firstName: FullName.dirty(tInvalidFirstName),
          isValid: false,
        ),
      ],
    );
    blocTest<ContactUsBloc, ContactUsState>(
      'emits updated state with valid firstName but isValid = true when valid seed is provided',
      build: () => contactUsBloc,
      seed: () => const ContactUsState(
        email: Email.dirty(tValidEmail),
        lastName: FullName.dirty(tValidLastName),
        message: FullName.dirty(tValidMessage),
      ),
      act: (bloc) =>
          bloc.add(const ContactUsFirstNameChanged(firstName: tValidFirstName)),
      expect: () => const <ContactUsState>[
        ContactUsState(
          email: Email.dirty(tValidEmail),
          firstName: FullName.dirty(tValidFirstName),
          lastName: FullName.dirty(tValidLastName),
          message: FullName.dirty(tValidMessage),
          isValid: true,
        ),
      ],
    );
  });
  group('ContactUsLastNameChanged', () {
    blocTest<ContactUsBloc, ContactUsState>(
      'emits updated state with valid lastName when lastName is valid',
      build: () => contactUsBloc,
      act: (bloc) =>
          bloc.add(const ContactUsLastNameChanged(lastName: tValidLastName)),
      expect: () => const <ContactUsState>[
        ContactUsState(
          lastName: FullName.dirty(tValidLastName),
        ),
      ],
    );
    blocTest<ContactUsBloc, ContactUsState>(
      'emits updated state with invalid lastName and isValid = false when lastName is invalid',
      build: () => contactUsBloc,
      act: (bloc) =>
          bloc.add(const ContactUsLastNameChanged(lastName: tInvalidLastName)),
      expect: () => const <ContactUsState>[
        ContactUsState(
          lastName: FullName.dirty(tInvalidLastName),
          isValid: false,
        ),
      ],
    );
    blocTest<ContactUsBloc, ContactUsState>(
      'emits updated state with valid lastName but isValid = true when valid seed is provided',
      build: () => contactUsBloc,
      seed: () => const ContactUsState(
        email: Email.dirty(tValidEmail),
        firstName: FullName.dirty(tValidFirstName),
        message: FullName.dirty(tValidMessage),
      ),
      act: (bloc) =>
          bloc.add(const ContactUsLastNameChanged(lastName: tValidLastName)),
      expect: () => const <ContactUsState>[
        ContactUsState(
          email: Email.dirty(tValidEmail),
          firstName: FullName.dirty(tValidFirstName),
          lastName: FullName.dirty(tValidLastName),
          message: FullName.dirty(tValidMessage),
          isValid: true,
        ),
      ],
    );
  });
  group('ContactUsEmailChanged', () {
    blocTest<ContactUsBloc, ContactUsState>(
      'emits updated state with valid email when email is valid',
      build: () => contactUsBloc,
      act: (bloc) => bloc.add(const ContactUsEmailChanged(email: tValidEmail)),
      expect: () => const <ContactUsState>[
        ContactUsState(
          email: Email.dirty(tValidEmail),
        ),
      ],
    );
    blocTest<ContactUsBloc, ContactUsState>(
      'emits updated state with invalid email and isValid = false when email is invalid',
      build: () => contactUsBloc,
      act: (bloc) =>
          bloc.add(const ContactUsEmailChanged(email: tInvalidEmail)),
      expect: () => const <ContactUsState>[
        ContactUsState(
          email: Email.dirty(tInvalidEmail),
          isValid: false,
        ),
      ],
    );
    blocTest<ContactUsBloc, ContactUsState>(
      'emits updated state with valid email but isValid = true when valid seed is provided',
      build: () => contactUsBloc,
      seed: () => const ContactUsState(
        firstName: FullName.dirty(tValidFirstName),
        lastName: FullName.dirty(tValidLastName),
        message: FullName.dirty(tValidMessage),
      ),
      act: (bloc) => bloc.add(const ContactUsEmailChanged(email: tValidEmail)),
      expect: () => const <ContactUsState>[
        ContactUsState(
          email: Email.dirty(tValidEmail),
          firstName: FullName.dirty(tValidFirstName),
          lastName: FullName.dirty(tValidLastName),
          message: FullName.dirty(tValidMessage),
          isValid: true,
        ),
      ],
    );
  });

  group('ContactUsMessageChanged', () {
    blocTest<ContactUsBloc, ContactUsState>(
      'emits updated state with valid message when message is valid',
      build: () => contactUsBloc,
      act: (bloc) =>
          bloc.add(const ContactUsMessageChanged(message: tValidMessage)),
      expect: () => const <ContactUsState>[
        ContactUsState(
          message: FullName.dirty(tValidMessage),
        ),
      ],
    );
    blocTest<ContactUsBloc, ContactUsState>(
      'emits updated state with invalid message and isValid = false when message is invalid',
      build: () => contactUsBloc,
      act: (bloc) =>
          bloc.add(const ContactUsMessageChanged(message: tInValidMessage)),
      expect: () => const <ContactUsState>[
        ContactUsState(
          message: FullName.dirty(tInValidMessage),
          isValid: false,
        ),
      ],
    );
    blocTest<ContactUsBloc, ContactUsState>(
      'emits updated state with valid message but isValid = true when valid seed is provided',
      build: () => contactUsBloc,
      seed: () => const ContactUsState(
        email: Email.dirty(tValidEmail),
        firstName: FullName.dirty(tValidFirstName),
        lastName: FullName.dirty(tValidLastName),
      ),
      act: (bloc) =>
          bloc.add(const ContactUsMessageChanged(message: tValidMessage)),
      expect: () => const <ContactUsState>[
        ContactUsState(
          email: Email.dirty(tValidEmail),
          firstName: FullName.dirty(tValidFirstName),
          lastName: FullName.dirty(tValidLastName),
          message: FullName.dirty(tValidMessage),
          isValid: true,
        ),
      ],
    );
  });

  group('ContactUsSubmitButtonPressed', () {
    blocTest<ContactUsBloc, ContactUsState>(
      'emits updated state with valid seed when button is pressed and sendEmail usecase returns a success string',
      build: () => contactUsBloc,
      wait: const Duration(milliseconds: 200),
      setUp: () => when(() => mockSendEmail(any()))
          .thenAnswer((_) async => const Right(tSuccessString)),
      seed: () => const ContactUsState(
        firstName: FullName.dirty(tValidFirstName),
        lastName: FullName.dirty(tValidLastName),
        email: Email.dirty(tValidEmail),
        message: FullName.dirty(tValidMessage),
      ),
      act: (bloc) => bloc.add(ContactUsSubmitButtonPressed()),
      expect: () => const <ContactUsState>[
        ContactUsState(
          firstName: FullName.dirty(tValidFirstName),
          lastName: FullName.dirty(tValidLastName),
          email: Email.dirty(tValidEmail),
          message: FullName.dirty(tValidMessage),
          isValid: true,
        ),
        ContactUsState(
            firstName: FullName.dirty(tValidFirstName),
            lastName: FullName.dirty(tValidLastName),
            email: Email.dirty(tValidEmail),
            message: FullName.dirty(tValidMessage),
            isValid: true,
            status: FormzSubmissionStatus.inProgress),
        ContactUsState(
            firstName: FullName.dirty(tValidFirstName),
            lastName: FullName.dirty(tValidLastName),
            email: Email.dirty(tValidEmail),
            message: FullName.dirty(tValidMessage),
            isValid: true,
            status: FormzSubmissionStatus.success),
        ContactUsState(
          firstName: FullName.pure(),
          lastName: FullName.pure(),
          email: Email.pure(),
          message: FullName.pure(),
          status: FormzSubmissionStatus.initial,
          isValid: false,
        )
      ],
    );
    blocTest<ContactUsBloc, ContactUsState>(
      'emits updated state with valid seed when button is pressed and sendEmail usecase returns a failure',
      build: () => contactUsBloc,
      wait: const Duration(milliseconds: 200),
      setUp: () => when(() => mockSendEmail(any()))
          .thenAnswer((_) async => const Left(Failure())),
      seed: () => const ContactUsState(
        firstName: FullName.dirty(tValidFirstName),
        lastName: FullName.dirty(tValidLastName),
        email: Email.dirty(tValidEmail),
        message: FullName.dirty(tValidMessage),
      ),
      act: (bloc) => bloc.add(ContactUsSubmitButtonPressed()),
      expect: () => <ContactUsState>[
        const ContactUsState(
          firstName: FullName.dirty(tValidFirstName),
          lastName: FullName.dirty(tValidLastName),
          email: Email.dirty(tValidEmail),
          message: FullName.dirty(tValidMessage),
          isValid: true,
        ),
        const ContactUsState(
            firstName: FullName.dirty(tValidFirstName),
            lastName: FullName.dirty(tValidLastName),
            email: Email.dirty(tValidEmail),
            message: FullName.dirty(tValidMessage),
            isValid: true,
            status: FormzSubmissionStatus.inProgress),
        ContactUsState(
          firstName: const FullName.dirty(tValidFirstName),
          lastName: const FullName.dirty(tValidLastName),
          email: const Email.dirty(tValidEmail),
          message: const FullName.dirty(tValidMessage),
          isValid: true,
          status: FormzSubmissionStatus.failure,
          errorMessage: const Failure().message,
        ),
        ContactUsState(
          firstName: const FullName.pure(),
          lastName: const FullName.pure(),
          email: const Email.pure(),
          message: const FullName.pure(),
          status: FormzSubmissionStatus.initial,
          isValid: false,
          errorMessage: const Failure().message,
        )
      ],
    );

    blocTest<ContactUsBloc, ContactUsState>(
      'emits updated state with invalid seed when button is pressed',
      build: () => contactUsBloc,
      seed: () => const ContactUsState(
        firstName: FullName.dirty(tInvalidFirstName),
        lastName: FullName.dirty(tValidLastName),
        email: Email.dirty(tValidEmail),
        message: FullName.dirty(tValidMessage),
        isValid:
            true, //Have to set isValid as true here because otherwise bloc will see it as the same state as before
      ),
      act: (bloc) => bloc.add(ContactUsSubmitButtonPressed()),
      expect: () => <ContactUsState>[
        const ContactUsState(
          firstName: FullName.dirty(tInvalidFirstName),
          lastName: FullName.dirty(tValidLastName),
          email: Email.dirty(tValidEmail),
          message: FullName.dirty(tValidMessage),
          isValid: false,
        ),
      ],
    );
  });
}
