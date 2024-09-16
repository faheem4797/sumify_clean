import 'package:fpdart/fpdart.dart';

import 'package:sumify_clean/core/constants/constants.dart';
import 'package:sumify_clean/core/error/failure.dart';
import 'package:sumify_clean/core/error/server_exception.dart';
import 'package:sumify_clean/core/network/connection_checker.dart';
import 'package:sumify_clean/features/contact_us/data/datasources/contact_us_remote_datasource.dart';
import 'package:sumify_clean/features/contact_us/data/models/contact_us_model.dart';
import 'package:sumify_clean/features/contact_us/domain/repositories/contact_us_repository.dart';

class ContactUsRepositoryImpl implements ContactUsRepository {
  final ConnectionChecker connectionChecker;
  final ContactUsRemoteDatasource contactUsRemoteDatasource;
  ContactUsRepositoryImpl({
    required this.connectionChecker,
    required this.contactUsRemoteDatasource,
  });
  @override
  Future<Either<Failure, String>> sendEmail(
      {required String firstName,
      required String lastName,
      required String email,
      required String message}) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(const Failure(Constants.noConnectionErrorMessage));
      }

      final contactUsModel = ContactUsModel(
          firstName: firstName,
          lastName: lastName,
          email: email,
          message: message);

      final response = await contactUsRemoteDatasource.sendContactEmail(
          contactUsModel: contactUsModel);

      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
