import 'package:sumify_clean/features/authentication/data/models/user_model.dart';

abstract interface class AuthRemoteDatasource {
  Future<UserModel> signupWithEmailAndPassword(
      {required String name, required String email, required String password});
  Future<UserModel> loginWithEmailAndPassword(
      {required String email, required String password});
  Future<UserModel?> getCurrentUserData();
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  @override
  Future<UserModel?> getCurrentUserData() {
    // TODO: implement getCurrentUserData
    throw UnimplementedError();
  }

  @override
  Future<UserModel> loginWithEmailAndPassword(
      {required String email, required String password}) {
    // TODO: implement loginWithEmailAndPassword
    throw UnimplementedError();
  }

  @override
  Future<UserModel> signupWithEmailAndPassword(
      {required String name, required String email, required String password}) {
    // TODO: implement signupWithEmailAndPassword
    throw UnimplementedError();
  }
}
