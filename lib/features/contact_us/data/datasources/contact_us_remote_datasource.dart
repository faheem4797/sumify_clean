import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sumify_clean/core/error/server_exception.dart';
import 'package:sumify_clean/features/contact_us/data/models/contact_us_model.dart';
import 'package:http/http.dart' as http;

abstract interface class ContactUsRemoteDatasource {
  Future<String> sendContactEmail({required ContactUsModel contactUsModel});
}

class ContactUsRemoteDatasourceImpl implements ContactUsRemoteDatasource {
  @override
  Future<String> sendContactEmail(
      {required ContactUsModel contactUsModel}) async {
    try {
      const String serviceId = 'service_9tz4peu';
      const String templateId = 'template_jkoixvw';
      const String userId = 'teMSbzGxAR-uv1HhS';

      final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
      final response = await http.post(
        url,
        headers: {
          'origin': 'http://localhost',
          'Content-Type': 'application/json'
        },
        body: json.encode({
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': userId,
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
      return 'Email Sent Successfully';
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
