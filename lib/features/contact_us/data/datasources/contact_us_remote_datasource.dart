import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sumify_clean/core/constants/constants.dart';
import 'package:sumify_clean/core/error/server_exception.dart';
import 'package:sumify_clean/core/secrets/app_secrets.dart';
import 'package:sumify_clean/features/contact_us/data/models/contact_us_model.dart';
import 'package:http/http.dart' as http;

abstract interface class ContactUsRemoteDatasource {
  Future<String> sendContactEmail({required ContactUsModel contactUsModel});
}

class ContactUsRemoteDatasourceImpl implements ContactUsRemoteDatasource {
  final http.Client client;

  const ContactUsRemoteDatasourceImpl({required this.client});
  @override
  Future<String> sendContactEmail(
      {required ContactUsModel contactUsModel}) async {
    try {
      final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
      final response = await client.post(
        url,
        headers: {
          'origin': 'http://localhost',
          'Content-Type': 'application/json'
        },
        body: json.encode({
          'service_id': AppSecrets.serviceId,
          'template_id': AppSecrets.templateId,
          'user_id': AppSecrets.userId,
          'template_params': {
            'user_name':
                '${contactUsModel.firstName} ${contactUsModel.lastName}',
            'from_email': contactUsModel.email,
            'user_message': contactUsModel.message
          }
        }),
      );
      debugPrint(response.body);
      debugPrint(response.statusCode.toString());
      switch (response.statusCode) {
        case 200:
          return Constants.contactUsEmailSentSuccessMessage;

        case 400:
          throw const ServerException(Constants.badRequestFailureMessage);

        case 401:
          throw const ServerException(
              Constants.unAuthorizedRequestFailureMessage);

        case 403:
          throw const ServerException(Constants.forbiddenRequestFailureMessage);

        case 404:
          throw const ServerException(Constants.notFoundFailureMessage);

        case 408:
          throw const ServerException(Constants.requestTimeoutFailureMessage);

        case 429:
          throw const ServerException(Constants.tooManyRequestsFailureMessage);

        case 500:
          throw const ServerException(
              Constants.internalServerErrorFailureMessage);

        case 502:
          throw const ServerException(Constants.badGatewayFailureMessage);

        case 503:
          throw const ServerException(
              Constants.serviceUnAvailableFailureMessage);

        case 504:
          throw const ServerException(Constants.gatewayTimeoutFailureMessage);

        default:
          throw const ServerException();
      }
    } on ServerException {
      rethrow;
    } catch (_) {
      throw const ServerException();
    }
  }
}
