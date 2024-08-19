import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:sumify_clean/core/constants/constants.dart';
import 'package:sumify_clean/core/error/server_exception.dart';
import 'package:sumify_clean/core/secrets/app_secrets.dart';
import 'package:sumify_clean/core/utils/split_string_by_digit.dart';
import 'package:sumify_clean/features/article/data/models/article_model.dart';
import 'package:http/http.dart' as http;

abstract interface class ArticleRemoteDatasource {
  Future<ArticleModel> setUserArticle({required String articleText});
}

class ArticleRemoteDatasourceImpl implements ArticleRemoteDatasource {
  Future<String> openaiChatCompletion(
      int maxTokens, String prompt, String articleText) async {
    const url = 'https://api.openai.com/v1/chat/completions';

    final response = await http.post(
      Uri.parse(url),
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
      throw Exception('Failed to perform OpenAI Chat Completion');
    }
  }

  @override
  Future<ArticleModel> setUserArticle({required String articleText}) async {
    try {
      final title =
          await openaiChatCompletion(150, Constants.titlePrompt, articleText);

      final summary = await openaiChatCompletion(
          150, Constants.summarizePrompt, articleText);

      final report =
          await openaiChatCompletion(300, Constants.reportPrompt, articleText);

      var commentsString = await openaiChatCompletion(
          150, Constants.commentsPrompt, articleText);
      final comments = splitStringByDigit(commentsString);

      final article = ArticleModel(
          article: articleText,
          title: title,
          summary: summary,
          report: report,
          comments: comments);

      return article;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
