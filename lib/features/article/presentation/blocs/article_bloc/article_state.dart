part of 'article_bloc.dart';

enum ArticleStatus { initial, loading, success, failure }

final class ArticleState extends Equatable {
  const ArticleState({
    this.articleText = '',
    this.article = Article.empty,
    this.status = ArticleStatus.initial,
    this.errorMessage,
  });
  final String articleText;
  final Article article;
  final ArticleStatus status;
  final String? errorMessage;

  @override
  List<Object?> get props => [articleText, article, status, errorMessage];

  ArticleState copyWith({
    String? articleText,
    Article? article,
    ArticleStatus? status,
    String? errorMessage,
  }) {
    return ArticleState(
      articleText: articleText ?? this.articleText,
      article: article ?? this.article,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
