import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sumify_clean/core/error/firebase_auth_exceptions.dart';
import 'package:sumify_clean/core/error/firebase_firestore_exceptions.dart';
import 'package:sumify_clean/core/error/server_exception.dart';
import 'package:sumify_clean/features/authentication/data/models/user_model.dart';

abstract interface class ProfileRemoteDataSource {
  Future<String> uploadProfileImage({
    required File image,
    required String fileName,
    required String userId,
    required String previousPictureFilePathFromFirebase,
  });
  Future<void> updateUserData(
      {required String userId, required String newPictureFilePathFromFirebase});
  Future<String> signOutUser();
  Future<UserModel> getUserData({required String userId});
  Future<void> deleteUserAccount(
      {required String email, required String password});
  Future<void> deleteUserData(
      {required String userId, required String filePathFromFirebasae});
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
  Future<String> signOutUser() async {
    try {
      await firebaseAuth.signOut();
      return 'Success';
    } on FirebaseException catch (e) {
      throw ServerException(e.code);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> getUserData({required String userId}) async {
    try {
      final userDoc =
          await firebaseFirestore.collection('users').doc(userId).get();

      if (userDoc.data() != null) {
        return UserModel.fromMap(userDoc.data()!);
      } else {
        throw const FirebaseDataFailure();
      }
    } on FirebaseException catch (e) {
      throw FirebaseDataFailure.fromCode(e.code);
    } catch (_) {
      throw const FirebaseDataFailure();
    }
  }

  @override
  Future<void> deleteUserAccount(
      {required String email, required String password}) async {
    try {
      User? user = firebaseAuth.currentUser;
      if (user != null) {
        UserCredential userReauthenticated =
            await user.reauthenticateWithCredential(
          EmailAuthProvider.credential(
            email: email,
            password: password,
          ),
        );
        if (userReauthenticated.user?.email == email) {
          await user.delete();
          await firebaseAuth.signOut();
          return;
        } else {
          throw const ReauthenticateUserFailure();
        }
      } else {
        throw const ReauthenticateUserFailure(
            'Please retry after logging in again');
      }
    } on FirebaseException catch (e) {
      throw ReauthenticateUserFailure.fromCode(e.code);
    } catch (_) {
      throw const ReauthenticateUserFailure();
    }
  }

  @override
  Future<void> deleteUserData(
      {required String userId, required String filePathFromFirebasae}) async {
    try {
      await firebaseFirestore.collection('users').doc(userId).delete();
      if (filePathFromFirebasae != '') {
        await firebaseStorage.refFromURL(filePathFromFirebasae).delete();
      }
    } on FirebaseException catch (e) {
      throw FirebaseDataFailure.fromCode(e.code);
    } catch (_) {
      throw const FirebaseDataFailure();
    }
  }
}
