import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/news_repository.dart';
import 'news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  final NewsRepository _repository;

  NewsCubit(this._repository) : super(NewsInitial());

  Future<void> fetchNewsByTab(String category) async {
    emit(NewsLoading());

    try {
      final articles = await _repository.getTopHeadlines(category: category);
      emit(NewsLoaded(articles));
      
    } catch (e) {
      final errorMessage = e.toString().replaceAll('Exception: ', '');
      emit(NewsError(errorMessage));
    }
  }
}