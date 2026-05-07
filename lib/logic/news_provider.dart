import 'package:flutter/foundation.dart';
import '../data/repositories/news_repository.dart';
import 'news_state.dart';

class NewsProvider extends ChangeNotifier {
  final NewsRepository _repository;
  NewsState _state = NewsInitial();

  NewsProvider(this._repository);

  NewsState get state => _state;

  Future<void> fetchNewsByTab(String category) async {
    _state = NewsLoading();
    notifyListeners();

    try {
      final articles = await _repository.getTopHeadlines(category: category);
      _state = NewsLoaded(articles);
      notifyListeners();
    } catch (e) {
      final errorMessage = e.toString().replaceAll('Exception: ', '');
      _state = NewsError(errorMessage);
      notifyListeners();
    }
  }
}
