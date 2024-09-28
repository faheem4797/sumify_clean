import 'package:sumify_clean/core/constants/constants.dart';
import 'package:sumify_clean/core/error/server_exception.dart';
import 'package:sumify_clean/core/utils/open_ai_service.dart';
import 'package:sumify_clean/core/utils/split_string_by_digit.dart';
import 'package:sumify_clean/features/article/data/models/article_model.dart';

abstract interface class ArticleRemoteDatasource {
  Future<ArticleModel> setUserArticle({required String articleText});
}

class ArticleRemoteDatasourceImpl implements ArticleRemoteDatasource {
  final OpenAiService openAiService;
  const ArticleRemoteDatasourceImpl({required this.openAiService});

  @override
  Future<ArticleModel> setUserArticle({required String articleText}) async {
    try {
      final title = await openAiService.openaiChatCompletion(
          150, Constants.titlePrompt, articleText);

      final summary = await openAiService.openaiChatCompletion(
          150, Constants.summarizePrompt, articleText);

      final report = await openAiService.openaiChatCompletion(
          300, Constants.reportPrompt, articleText);

      var commentsString = await openAiService.openaiChatCompletion(
          150, Constants.commentsPrompt, articleText);
      final comments = splitStringByDigit(commentsString);

      final article = ArticleModel(
          article: articleText,
          title: title,
          summary: summary,
          report: report,
          comments: comments);

      return article;
    } on ServerException {
      rethrow;
    } catch (_) {
      throw const ServerException();
    }
  }
}
