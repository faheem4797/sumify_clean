import 'package:fpdart/fpdart.dart';
import 'package:sumify_clean/core/error/failure.dart';
import 'package:sumify_clean/core/usecase/usecase.dart';
import 'package:sumify_clean/features/article/domain/repositories/article_repository.dart';

class SaveAsPdf implements UseCase<String, SaveAsPdfParams> {
  final ArticleRepository articleRepository;

  SaveAsPdf({required this.articleRepository});
  @override
  Future<Either<Failure, String>> call(SaveAsPdfParams params) async {
    return await articleRepository.saveAsPdf(
        report: params.report, fileName: params.fileName);
  }
}

class SaveAsPdfParams {
  final String report;
  final String fileName;

  SaveAsPdfParams({required this.report, required this.fileName});
}
