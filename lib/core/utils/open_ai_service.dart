import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:sumify_clean/core/constants/constants.dart';
import 'package:sumify_clean/core/error/server_exception.dart';
import 'package:sumify_clean/core/secrets/app_secrets.dart';
import 'package:http/http.dart' as http;

class OpenAiService {
  final http.Client client;
  const OpenAiService({required this.client});

  Future<String> openaiChatCompletion(
      int maxTokens, String prompt, String articleText) async {
    try {
      final url = Uri.parse('https://api.openai.com/v1/chat/completions');

      final response = await client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${AppSecrets.apiKey}',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo-1106',
          'messages': [
            {'role': 'user', 'content': 'You: $articleText'},
            {'role': 'assistant', 'content': prompt}
          ],
          //messages,
          'max_tokens': maxTokens,
        }),
      );

      if (response.statusCode == 200) {
        debugPrint(response.body);

        Map<String, dynamic> parsedReponse = json.decode(response.body);

        String reply = parsedReponse['choices'][0]['message']['content'];

        return reply;
      } else {
        throw const ServerException(
            Constants.openAiServerExceptionFailureMessage);
      }
    } on ServerException {
      rethrow;
    } catch (_) {
      throw const ServerException();
    }
  }
}
