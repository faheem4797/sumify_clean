import 'package:equatable/equatable.dart';

class Article extends Equatable {
  final String article;
  final String title;
  final String summary;
  final String report;
  final List<String> comments;
  const Article({
    required this.article,
    required this.title,
    required this.summary,
    required this.report,
    required this.comments,
  });

  static const empty =
      Article(article: '', title: '', summary: '', report: '', comments: []);

  @override
  List<Object?> get props => [article, title, summary, report, comments];
}
