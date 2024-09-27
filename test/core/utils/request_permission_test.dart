import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sumify_clean/core/utils/request_permission.dart';

class MockPermissionsService extends Mock implements PermissionsService {}

class FakePermission extends Fake implements Permission {}

void main() {
  late MockPermissionsService mockPermissionsService;
  late PermissionRequest permissionRequest;
  setUp(() {
    mockPermissionsService = MockPermissionsService();
    permissionRequest =
        PermissionRequest(permissionsService: mockPermissionsService);
    registerFallbackValue(FakePermission());
  });

  void setUpStatusAsDenied() {
    when(() => mockPermissionsService.status(any()))
        .thenAnswer((_) async => PermissionStatus.denied);
  }

  void setUpRequestAsGranted() {
    when(() => mockPermissionsService.request(any()))
        .thenAnswer((_) async => PermissionStatus.granted);
  }

  void setUpRequestAsDenied() {
    when(() => mockPermissionsService.request(any()))
        .thenAnswer((_) async => PermissionStatus.denied);
  }

  test(
    'should return true when permission is already granted',
    () async {
      // Arrange
      when(() => mockPermissionsService.status(any()))
          .thenAnswer((_) async => PermissionStatus.granted);

      // Act
      final result = await permissionRequest
          .requestPermission(Permission.manageExternalStorage);

      // Assert
      verify(() =>
          mockPermissionsService.status(Permission.manageExternalStorage));
      expect(result, isTrue);
    },
  );

  test(
    'should forward the call to permissionsService.request() when the permission is not already granted',
    () async {
      //arrange
      setUpStatusAsDenied();
      setUpRequestAsGranted();

      await permissionRequest
          .requestPermission(Permission.manageExternalStorage);

      // Assert
      verify(() =>
          mockPermissionsService.status(Permission.manageExternalStorage));
      verify(() =>
          mockPermissionsService.request(Permission.manageExternalStorage));
    },
  );

  test(
    'should return true when the call to permissionsService.request() returns  PermissionStatus.granted',
    () async {
      //arrange
      setUpStatusAsDenied();
      setUpRequestAsGranted();
      final result = await permissionRequest
          .requestPermission(Permission.manageExternalStorage);

      // Assert
      verify(() =>
          mockPermissionsService.status(Permission.manageExternalStorage));
      verify(() =>
          mockPermissionsService.request(Permission.manageExternalStorage));
      expect(result, isTrue);
    },
  );

  test(
    'should forward the call to openAppSettings and return false when the call to permissionsService.request() returns  PermissionStatus.denied',
    () async {
      //arrange
      setUpStatusAsDenied();
      setUpRequestAsDenied();
      when(() => mockPermissionsService.openAppSettings())
          .thenAnswer((_) async => true);

      final result = await permissionRequest
          .requestPermission(Permission.manageExternalStorage);

      // Assert
      verify(() =>
          mockPermissionsService.status(Permission.manageExternalStorage));
      verify(() =>
          mockPermissionsService.request(Permission.manageExternalStorage));
      verify(() => mockPermissionsService.openAppSettings());
      expect(result, isFalse);
    },
  );

  test(
      'should return false when an exception occurs during permissionsService.request() call',
      () async {
    //arrange
    setUpStatusAsDenied();
    when(() => mockPermissionsService.request(any())).thenThrow(Exception());

    final result = await permissionRequest
        .requestPermission(Permission.manageExternalStorage);

    //assert
    verify(
        () => mockPermissionsService.status(Permission.manageExternalStorage));
    verify(
        () => mockPermissionsService.request(Permission.manageExternalStorage));
    verifyNever(() => mockPermissionsService.openAppSettings());

    expect(result, isFalse);
  });

  test(
      'should return false when an exception occurs during openAppSettings call',
      () async {
    //arrange
    setUpStatusAsDenied();
    setUpRequestAsDenied();
    when(() => mockPermissionsService.openAppSettings())
        .thenThrow((_) => Exception());

    final result = await permissionRequest
        .requestPermission(Permission.manageExternalStorage);

    //assert
    verify(
        () => mockPermissionsService.status(Permission.manageExternalStorage));
    verify(
        () => mockPermissionsService.request(Permission.manageExternalStorage));
    verify(() => mockPermissionsService.openAppSettings());
    expect(result, isFalse);
  });
}
