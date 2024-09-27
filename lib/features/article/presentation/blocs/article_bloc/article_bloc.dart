import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sumify_clean/features/article/domain/entities/article.dart';
import 'package:sumify_clean/features/article/domain/usecases/save_as_pdf.dart';
import 'package:sumify_clean/features/article/domain/usecases/set_article.dart';

part 'article_event.dart';
part 'article_state.dart';

class ArticleBloc extends Bloc<ArticleEvent, ArticleState> {
  final SetArticle _setArticle;
  final SaveAsPdf _saveAsPdf;
  ArticleBloc({required SetArticle setArticle, required SaveAsPdf saveAsPdf})
      : _setArticle = setArticle,
        _saveAsPdf = saveAsPdf,
        super(const ArticleState()) {
    on<SetArticleButtonPressed>(_setArticleButtonPressed);
    on<ArticleTextChanged>(_articleTextChanged);
    on<SaveAsPdfButtonPressed>(_saveAsPdfButtonPressed);
  }

  FutureOr<void> _setArticleButtonPressed(
      SetArticleButtonPressed event, Emitter<ArticleState> emit) async {
    emit(state.copyWith(status: ArticleStatus.loading));
    if (state.articleText == '') {
      emit(state.copyWith(status: ArticleStatus.initial));
      return;
    }
    final response =
        await _setArticle(SetArticleParams(article: state.articleText));
    response.fold(
      (l) => emit(state.copyWith(
          status: ArticleStatus.failure, errorMessage: l.message)),
      (r) => emit(state.copyWith(status: ArticleStatus.success, article: r)),
    );
    await Future.delayed(const Duration(milliseconds: 200));
    emit(state.copyWith(status: ArticleStatus.initial));
  }

  FutureOr<void> _articleTextChanged(
      ArticleTextChanged event, Emitter<ArticleState> emit) {
    emit(state.copyWith(articleText: event.articleText));
  }

  FutureOr<void> _saveAsPdfButtonPressed(
      SaveAsPdfButtonPressed event, Emitter<ArticleState> emit) async {
    emit(state.copyWith(reportStatus: ReportSaveStatus.loading));
    if (state.article.report.isEmpty || state.article.title.isEmpty) {
      emit(state.copyWith(reportStatus: ReportSaveStatus.initial));
      return;
    }
    final String title = state.article.title;
    final String filteredtitle = title.replaceAll('"', '');

    final response = await _saveAsPdf(
        SaveAsPdfParams(report: state.article.report, fileName: filteredtitle));

    response.fold(
      (l) => emit(state.copyWith(
          reportStatus: ReportSaveStatus.failure,
          reportErrorMessage: l.message)),
      (r) => emit(state.copyWith(
        reportStatus: ReportSaveStatus.success,
        reportSuccessMessage: r,
      )),
    );
    await Future.delayed(const Duration(milliseconds: 200));
    emit(state.copyWith(reportStatus: ReportSaveStatus.initial));
  }
}
