import 'dart:convert';

import 'package:sumify_clean/features/article/domain/entities/article.dart';

class ArticleModel extends Article {
  ArticleModel({
    required super.article,
    required super.title,
    required super.summary,
    required super.report,
    required super.comments,
  });

  ArticleModel copyWith({
    String? article,
    String? title,
    String? summary,
    String? report,
    List<String>? comments,
  }) {
    return ArticleModel(
      article: article ?? this.article,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      report: report ?? this.report,
      comments: comments ?? this.comments,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'article': article,
      'title': title,
      'summary': summary,
      'report': report,
      'comments': comments,
    };
  }

  factory ArticleModel.fromMap(Map<String, dynamic> map) {
    return ArticleModel(
      article: map['article'] ?? '',
      title: map['title'] ?? '',
      summary: map['summary'] ?? '',
      report: map['report'] ?? '',
      comments: List<String>.from(map['comments']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ArticleModel.fromJson(String source) =>
      ArticleModel.fromMap(json.decode(source));
}
