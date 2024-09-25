import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sumify_clean/core/domain/entities/app_user.dart';
import 'package:sumify_clean/core/error/failure.dart';
import 'package:sumify_clean/features/profile/domain/usecases/delete_account.dart';
import 'package:sumify_clean/features/profile/presentation/blocs/delete_account_bloc/delete_account_bloc.dart';

class MockDeleteAccount extends Mock implements DeleteAccount {}

class FakeDeleteAccountParams extends Fake implements DeleteAccountParams {}

void main() {
  late DeleteAccountBloc deleteAccountBloc;
  late MockDeleteAccount mockDeleteAccount;

  setUpAll(() {
    registerFallbackValue(FakeDeleteAccountParams());
  });

  setUp(() {
    mockDeleteAccount = MockDeleteAccount();
    deleteAccountBloc = DeleteAccountBloc(deleteAccount: mockDeleteAccount);
  });
  tearDown(() => deleteAccountBloc.close());
  test(
    'should have [DeleteAccountInitial] state when Delete Account Bloc is initialized',
    () async {
      //assert
      expect(deleteAccountBloc.state, DeleteAccountInitial());
    },
  );
  group('DeleteUserAccountEvent', () {
    const tSuccessMessage = 'Success';
    const tFailureMessage = 'Failure';
    const tId = '123';
    const tName = 'test name';
    const tPassword = '12345678';
    const tEmail = 'test@example.com';

    const tAppUser = AppUser(id: tId, name: tName, email: tEmail);

    blocTest<DeleteAccountBloc, DeleteAccountState>(
      'emits [DeleteAccountLoading, DeleteAccountSuccess] when DeleteUserAccountEvent is added and DeleteAccount usecase returns a success string.',
      build: () => deleteAccountBloc,
      setUp: () => when(() => mockDeleteAccount(any()))
          .thenAnswer((_) async => const Right(tSuccessMessage)),
      act: (bloc) => bloc.add(const DeleteUserAccountEvent(
          appUser: tAppUser, email: tEmail, password: tPassword)),
      expect: () => <DeleteAccountState>[
        DeleteAccountLoading(),
        const DeleteAccountSuccess(message: tSuccessMessage)
      ],
      verify: (bloc) {
        verify(() => mockDeleteAccount(const DeleteAccountParams(
            email: tEmail, password: tPassword, appUser: tAppUser))).called(1);
      },
    );
    blocTest<DeleteAccountBloc, DeleteAccountState>(
      'emits [DeleteAccountLoading, DeleteAccountFailure] when DeleteUserAccountEvent is added and DeleteAccount usecase returns a failure.',
      build: () => deleteAccountBloc,
      setUp: () => when(() => mockDeleteAccount(any()))
          .thenAnswer((_) async => const Left(Failure(tFailureMessage))),
      act: (bloc) => bloc.add(const DeleteUserAccountEvent(
          appUser: tAppUser, email: tEmail, password: tPassword)),
      expect: () => <DeleteAccountState>[
        DeleteAccountLoading(),
        const DeleteAccountFailure(message: tFailureMessage)
      ],
      verify: (bloc) {
        verify(() => mockDeleteAccount(const DeleteAccountParams(
            email: tEmail, password: tPassword, appUser: tAppUser))).called(1);
      },
    );
  });
}
