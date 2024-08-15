import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sumify_clean/core/error/firebase_firestore_exceptions.dart';
import 'package:sumify_clean/core/error/server_exception.dart';

abstract interface class ProfileRemoteDataSource {
  Future<String> uploadProfileImage({
    required File image,
    required String fileName,
    required String userId,
    required String previousPictureFilePathFromFirebase,
  });
  Future<void> updateUserData(
      {required String userId, required String newPictureFilePathFromFirebase});
  Future<void> signOutUser();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final FirebaseStorage firebaseStorage;
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;

  ProfileRemoteDataSourceImpl(
      {required this.firebaseAuth,
      required this.firebaseStorage,
      required this.firebaseFirestore});
  @override
  Future<void> updateUserData(
      {required String userId,
      required String newPictureFilePathFromFirebase}) async {
    try {
      return await firebaseFirestore.collection('users').doc(userId).update({
        'pictureFilePathFromFirebase': newPictureFilePathFromFirebase,
      });
    } on FirebaseException catch (e) {
      throw FirebaseDataFailure.fromCode(e.code);
    } catch (_) {
      throw const FirebaseDataFailure();
    }
  }

  @override
  Future<String> uploadProfileImage(
      {required File image,
      required String fileName,
      required String userId,
      required String previousPictureFilePathFromFirebase}) async {
    try {
      int randomNumber = Random().nextInt(100000) + 100000;
      final profileImageRef = firebaseStorage
          .ref()
          .child('profile_image/$userId/$randomNumber$fileName');
      UploadTask profileImageUploadTask = profileImageRef.putFile(image);
      final profileImageSnapshot =
          await profileImageUploadTask.whenComplete(() => {});

      final String profileImageUrlDownload =
          await profileImageSnapshot.ref.getDownloadURL();

      if (previousPictureFilePathFromFirebase != '') {
        await firebaseStorage
            .refFromURL(previousPictureFilePathFromFirebase)
            .delete();
      }

      return profileImageUrlDownload;
    } on FirebaseException catch (e) {
      throw FirebaseDataFailure.fromCode(e.code);
    } catch (e) {
      throw const FirebaseDataFailure();
    }
  }

  @override
  Future<void> signOutUser() async {
    try {
      await firebaseAuth.signOut();
      return;
    } on FirebaseException catch (e) {
      throw ServerException(e.code);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
