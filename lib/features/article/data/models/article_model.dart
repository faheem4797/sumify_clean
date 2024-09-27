import 'package:sumify_clean/features/article/domain/entities/article.dart';

class ArticleModel extends Article {
  const ArticleModel({
    required super.article,
    required super.title,
    required super.summary,
    required super.report,
    required super.comments,
  });
}
