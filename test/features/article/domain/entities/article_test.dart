import 'package:flutter_test/flutter_test.dart';
import 'package:sumify_clean/features/article/domain/entities/article.dart';

void main() {
  test(
    'should return an empty article',
    () async {
      //act
      const result = Article.empty;

      //assert
      expect(
        result,
        isA<Article>()
            .having((article) => article.article, 'article', '')
            .having((article) => article.title, 'title', '')
            .having((article) => article.summary, 'summary', '')
            .having((article) => article.report, 'report', '')
            .having((article) => article.comments, 'comments', List.empty()),
      );
    },
  );
}
