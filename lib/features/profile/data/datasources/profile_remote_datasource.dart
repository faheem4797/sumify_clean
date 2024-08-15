import 'dart:io';

abstract interface class ProfileRemoteDataSource {
  Future<String> uploadProfileImage({
    required File image,
    required String fileName,
    required String userId,
    required String previousPictureFilePathFromFirebase,
  });
  Future<void> updateUserData(
      {required String userId, required String newPictureFilePathFromFirebase});
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  @override
  Future<void> updateUserData(
      {required String userId,
      required String newPictureFilePathFromFirebase}) {
    // TODO: implement updateUserData
    throw UnimplementedError();
  }

  @override
  Future<String> uploadProfileImage(
      {required File image,
      required String fileName,
      required String userId,
      required String previousPictureFilePathFromFirebase}) {
    // TODO: implement uploadProfileImage
    throw UnimplementedError();
  }
}
