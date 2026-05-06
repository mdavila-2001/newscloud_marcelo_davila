import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/news_model.dart';

class NewsRepository {
  final Dio _dio;

  NewsRepository()
      : _dio = Dio(
          BaseOptions(
            baseUrl: dotenv.get('NEWS_BASE_URL', fallback: 'https://newsapi.org/v2'),
            queryParameters: {
              'apiKey': dotenv.get('NEWS_API_KEY'),
              'country': 'us',
            },
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
          ),
        ) {
    _dio.interceptors.add(
      LogInterceptor(
        requestHeader: false,
        responseHeader: false,
        requestBody: true,
        responseBody: true,
      ),
    );
  }

  Future<List<Article>> getTopHeadlines({required String category}) async {
    try {
      final response = await _dio.get(
        '/top-headlines',
        queryParameters: {
          'category': category,
        },
      );

      if (response.statusCode == 200) {
        final newsResponse = NewsResponse.fromJson(response.data);
        return newsResponse.articles.where((article) => 
          article.title != '[Removed]' && article.title.isNotEmpty
        ).toList();
      } else {
        throw Exception('Fallo al cargar las noticias. Código: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Error inesperado procesando la información: $e');
    }
  }

  Exception _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Tiempo de espera agotado. Revisa tu conexión a internet.');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data['message'] ?? 'Error desconocido del servidor';
        return Exception('Error $statusCode: $message');
      case DioExceptionType.connectionError:
        return Exception('Sin conexión a internet.');
      default:
        return Exception('Error de red inesperado.');
    }
  }
}