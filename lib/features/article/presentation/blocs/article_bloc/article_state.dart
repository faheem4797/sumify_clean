part of 'article_bloc.dart';

enum ArticleStatus { initial, loading, success, failure }

enum ReportSaveStatus { initial, loading, success, failure }

final class ArticleState extends Equatable {
  const ArticleState({
    this.articleText = '',
    this.article = Article.empty,
    this.status = ArticleStatus.initial,
    this.reportStatus = ReportSaveStatus.initial,
    this.errorMessage,
    this.reportErrorMessage,
  });
  final String articleText;
  final Article article;
  final ArticleStatus status;
  final String? errorMessage;
  final ReportSaveStatus reportStatus;
  final String? reportErrorMessage;

  @override
  List<Object?> get props => [
        articleText,
        article,
        status,
        errorMessage,
        reportStatus,
        reportErrorMessage
      ];

  ArticleState copyWith({
    String? articleText,
    Article? article,
    ArticleStatus? status,
    String? errorMessage,
    ReportSaveStatus? reportStatus,
    String? reportErrorMessage,
  }) {
    return ArticleState(
      articleText: articleText ?? this.articleText,
      article: article ?? this.article,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      reportStatus: reportStatus ?? this.reportStatus,
      reportErrorMessage: reportErrorMessage ?? this.reportErrorMessage,
    );
  }
}
