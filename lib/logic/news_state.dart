import 'package:flutter/foundation.dart';
import '../data/models/news_model.dart';

@immutable
abstract class NewsState {}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class NewsLoaded extends NewsState {
  final List<Article> articles;

  NewsLoaded(this.articles);
}

class NewsError extends NewsState {
  final String message;

  NewsError(this.message);
}