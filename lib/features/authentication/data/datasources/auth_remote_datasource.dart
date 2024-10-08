import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sumify_clean/core/constants/constants.dart';
import 'package:sumify_clean/core/error/firebase_auth_exceptions.dart';
import 'package:sumify_clean/core/error/firebase_firestore_exceptions.dart';
import 'package:sumify_clean/features/authentication/data/models/user_model.dart';

abstract interface class AuthRemoteDatasource {
  User? get getCurrentUser;
  Future<String> signupWithEmailAndPassword(
      {required String email, required String password});
  Future<String> loginWithEmailAndPassword(
      {required String email, required String password});
  Future<String> forgotUserPassword({required String email});

  Future<UserModel> getUserData({required String id});
  Future<void> setUserData({required UserModel userModel});
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final FirebaseAuth firebaseAuth;
  // final usersCollection = FirebaseFirestore.instance.collection('users');
  final FirebaseFirestore firebaseFirestore;

  AuthRemoteDatasourceImpl({
    required this.firebaseAuth,
    required this.firebaseFirestore,
  });

  @override
  Future<UserModel> getUserData({required String id}) async {
    try {
      final userDoc = await firebaseFirestore.collection('users').doc(id).get();

      if ((userDoc.data() == null) ||
          (userDoc.data()!.isEmpty || (!userDoc.exists))) {
        throw const FirebaseDataFailure(Constants.userDataNotFoundErrorMessage);
      } else {
        return UserModel.fromMap(userDoc.data()!);
      }
    } on FirebaseException catch (e) {
      throw FirebaseDataFailure.fromCode(e.code);
    } on FirebaseDataFailure {
      rethrow;
    } catch (_) {
      throw const FirebaseDataFailure();
    }
  }

  @override
  Future<void> setUserData({required UserModel userModel}) async {
    try {
      return await firebaseFirestore
          .collection('users')
          .doc(userModel.id)
          .set(userModel.toMap());
    } on FirebaseException catch (e) {
      throw FirebaseDataFailure.fromCode(e.code);
    } catch (_) {
      throw const FirebaseDataFailure();
    }
  }

  @override
  Future<String> loginWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final UserCredential userCredentials = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredentials.user == null) {
        throw const SignInWithEmailAndPasswordFailure(
            Constants.userIsNullErrorMessage);
      }
      return userCredentials.user!.uid;
    } on FirebaseAuthException catch (e) {
      throw SignInWithEmailAndPasswordFailure.fromCode(e.code);
    } on SignInWithEmailAndPasswordFailure {
      rethrow;
    } catch (_) {
      throw const SignInWithEmailAndPasswordFailure();
    }
  }

  @override
  Future<String> signupWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final userCredentials = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (userCredentials.user == null) {
        throw const SignUpWithEmailAndPasswordFailure(
            Constants.userIsNullErrorMessage);
      }
      return userCredentials.user!.uid;
    } on FirebaseAuthException catch (e) {
      throw SignUpWithEmailAndPasswordFailure.fromCode(e.code);
    } on SignUpWithEmailAndPasswordFailure {
      rethrow;
    } catch (_) {
      throw const SignUpWithEmailAndPasswordFailure();
    }
  }

  @override
  Future<String> forgotUserPassword({required String email}) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);

      return Constants.passwordResetSuccessMessage;
    } on FirebaseAuthException catch (e) {
      throw SendPasswordResetEmailFailure.fromCode(e.code);
    } catch (e) {
      throw const SendPasswordResetEmailFailure();
    }
  }

  @override
  User? get getCurrentUser => firebaseAuth.currentUser;
}
