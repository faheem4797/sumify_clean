import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sumify_clean/core/utils/request_permission.dart';

class MockPermission extends Mock implements Permission {}

void main() {
  late MockPermission mockPermission;
  setUp(() {
    mockPermission = MockPermission();
  });

  // test(
  //   'should return true when permission is already granted',
  //   () async {
  //     // Arrange
  //     when(() => mockPermission.isGranted).thenAnswer((_) async => true);

  //     // Act
  //     final result = await requestPermission(mockPermission);

  //     // Assert
  //     verify(() => mockPermission.isGranted);
  //     expect(result, isTrue);
  //   },
  // );
}
