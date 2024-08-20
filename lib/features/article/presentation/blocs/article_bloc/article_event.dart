part of 'article_bloc.dart';

sealed class ArticleEvent extends Equatable {
  const ArticleEvent();

  @override
  List<Object> get props => [];
}

class SetArticleButtonPressed extends ArticleEvent {}

class ArticleTextChanged extends ArticleEvent {
  final String articleText;
  const ArticleTextChanged({required this.articleText});
  @override
  List<Object> get props => [articleText];
}
