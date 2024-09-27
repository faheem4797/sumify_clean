import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sumify_clean/core/error/failure.dart';
import 'package:sumify_clean/features/article/domain/repositories/article_repository.dart';
import 'package:sumify_clean/features/article/domain/usecases/save_as_pdf.dart';

class MockArticleRepository extends Mock implements ArticleRepository {}

void main() {
  late MockArticleRepository mockArticleRepository;
  late SaveAsPdf saveAsPdf;

  setUp(() {
    mockArticleRepository = MockArticleRepository();
    saveAsPdf = SaveAsPdf(articleRepository: mockArticleRepository);
  });

  const tSuccessMessage = 'Success';

  const tReport = 'Report Text';
  const tFileName = 'File Name';

  test(
    'should return a success string from the article repository',
    () async {
      //arrange
      when(() => mockArticleRepository.saveAsPdf(
              report: any(named: 'report'), fileName: any(named: 'fileName')))
          .thenAnswer((_) async => const Right(tSuccessMessage));

      //act
      final result = await saveAsPdf(
          SaveAsPdfParams(report: tReport, fileName: tFileName));

      //assert
      expect(result, const Right(tSuccessMessage));
      verify(() => mockArticleRepository.saveAsPdf(
          report: tReport, fileName: tFileName)).called(1);
      verifyNoMoreInteractions(mockArticleRepository);
    },
  );

  test(
    'should return a failure from the article repository',
    () async {
      //arrange
      when(() => mockArticleRepository.saveAsPdf(
              report: any(named: 'report'), fileName: any(named: 'fileName')))
          .thenAnswer((_) async => const Left(Failure()));

      //act
      final result = await saveAsPdf(
          SaveAsPdfParams(report: tReport, fileName: tFileName));

      //assert
      expect(result, const Left(Failure()));
      verify(() => mockArticleRepository.saveAsPdf(
          report: tReport, fileName: tFileName)).called(1);
      verifyNoMoreInteractions(mockArticleRepository);
    },
  );
}
