import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sumify_clean/features/article/domain/entities/article.dart';
import 'package:sumify_clean/features/article/domain/usecases/set_article.dart';

part 'article_event.dart';
part 'article_state.dart';

class ArticleBloc extends Bloc<ArticleEvent, ArticleState> {
  final SetArticle _setArticle;
  ArticleBloc({required SetArticle setArticle})
      : _setArticle = setArticle,
        super(const ArticleState()) {
    on<SetArticleButtonPressed>(_setArticleButtonPressed);
    on<ArticleTextChanged>(_articleTextChanged);
  }

  FutureOr<void> _setArticleButtonPressed(
      SetArticleButtonPressed event, Emitter<ArticleState> emit) async {
    emit(state.copyWith(status: ArticleStatus.loading));
    if (state.articleText == '') return;
    final response =
        await _setArticle(SetArticleParams(article: state.articleText));
    response.fold(
      (l) => emit(state.copyWith(
          status: ArticleStatus.failure, errorMessage: l.message)),
      (r) => emit(state.copyWith(status: ArticleStatus.success, article: r)),
    );

    emit(state.copyWith(status: ArticleStatus.initial));
  }

  FutureOr<void> _articleTextChanged(
      ArticleTextChanged event, Emitter<ArticleState> emit) {
    emit(state.copyWith(articleText: event.articleText));
  }
}
