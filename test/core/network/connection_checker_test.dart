import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sumify_clean/core/network/connection_checker.dart';

class MockInternetConnectionChecker extends Mock
    implements InternetConnection {}

void main() {
  late MockInternetConnectionChecker mockInternetConnectionChecker;
  late ConnectionCheckerImpl connectionCheckerImpl;

  setUp(() {
    mockInternetConnectionChecker = MockInternetConnectionChecker();
    connectionCheckerImpl =
        ConnectionCheckerImpl(mockInternetConnectionChecker);
  });

  group('isConnected', () {
    test(
        'should forward the call to InternetConnectionChecker.hasInternetAccess',
        () async {
      when(() => mockInternetConnectionChecker.hasInternetAccess)
          .thenAnswer((_) async => true);

      final result = await connectionCheckerImpl.isConnected;

      verify(() => mockInternetConnectionChecker.hasInternetAccess);
      expect(result, true);
    });
  });
}
