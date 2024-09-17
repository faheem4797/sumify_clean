import 'package:flutter_test/flutter_test.dart';
import 'package:sumify_clean/features/authentication/data/models/user_model.dart';

void main() {
  const tUserModel = UserModel(
    id: '1',
    name: 'Test User',
    email: 'test@example.com',
    pictureFilePathFromFirebase: 'test/path/to/picture.png',
  );

  const tUserModelMap = {
    'id': '1',
    'name': 'Test User',
    'email': 'test@example.com',
    'pictureFilePathFromFirebase': 'test/path/to/picture.png',
  };

  group('UserModel', () {
    test(
      'toMap should return a valid map representation of UserModel',
      () async {
        // Act
        final map = tUserModel.toMap();

        // Assert
        expect(map, tUserModelMap);
      },
    );

    test(
      'fromMap should create a valid UserModel object from a map',
      () async {
        // Arrange

        // Act
        final result = UserModel.fromMap(tUserModelMap);

        // Assert
        expect(result, tUserModel);
      },
    );

    test(
      'fromMap should handle missing fields with default values',
      () async {
        // Arrange
        final map = {
          'id': '2',
          'name': 'New User',
          // 'email' is missing, 'pictureFilePathFromFirebase' is missing
        };

        // Act
        final result = UserModel.fromMap(map);

        // Assert
        expect(result.id, '2');
        expect(result.name, 'New User');
        expect(result.email, '');
        expect(result.pictureFilePathFromFirebase, isNull);
      },
    );
  });
}
