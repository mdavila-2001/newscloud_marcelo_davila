class NewsResponse {
  final String status;
  final int totalResults;
  final List<Article> articles;

  NewsResponse({
    required this.status,
    required this.totalResults,
    required this.articles,
  });

  factory NewsResponse.fromJson(Map<String, dynamic> json) => NewsResponse(
    status: json['status'],
    totalResults: json['totalResults'],
    articles: List<Article>.from(json['articles'].map((x) => Article.fromJson(x))),
  );
}

class Article {
  final Source source;
  final String title;
  final String? description;
  final String? urlToImage;
  final String? publishedAt;
  final String? content;
  final String? url;

  Article({
    required this.source,
    required this.title,
    this.description,
    this.urlToImage,
    this.publishedAt,
    this.content,
    this.url,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      source: Source.fromJson(json['source']),
      title: json['title'] ?? 'Sin título',
      description: json['description'],
      urlToImage: json['urlToImage'],
      publishedAt: json['publishedAt'],
      content: json['content'],
      url: json['url'],
    );
  }
}

class Source {
  final String? id;
  final String name;

  Source({this.id, required this.name});

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      id: json['id'],
      name: json['name'] ?? 'Fuente desconocida',
    );
  }
}