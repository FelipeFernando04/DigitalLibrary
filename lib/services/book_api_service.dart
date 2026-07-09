import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/book.dart';
import '../utils/app_constants.dart';

class BookApiService {
  BookApiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<List<Book>> searchBooks(String query) async {
    final normalizedQuery = query.trim();

    if (normalizedQuery.isEmpty) {
      return const [];
    }

    final uri = Uri.https(
      AppConstants.openLibraryHost,
      AppConstants.searchPath,
      {
        'q': normalizedQuery,
        'fields':
            'key,title,author_name,cover_i,first_publish_year,publisher,language,subject,first_sentence',
        'limit': AppConstants.searchLimit.toString(),
        'lang': 'pt',
      },
    );

    try {
      final response = await _client
          .get(
            uri,
            headers: const {'Accept': 'application/json'},
          )
          .timeout(const Duration(seconds: 12));

      if (response.statusCode != 200) {
        throw BookApiException(
          'A Open Library respondeu com o código ${response.statusCode}.',
        );
      }

      final decoded = jsonDecode(
        utf8.decode(response.bodyBytes),
      );

      if (decoded is! Map<String, dynamic>) {
        throw const BookApiException(
          'A resposta recebida da API está em um formato inesperado.',
        );
      }

      final docs = decoded['docs'];
      if (docs is! List) {
        return const [];
      }

      return docs
          .whereType<Map>()
          .map(
            (item) => Book.fromOpenLibraryJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList();
    } on TimeoutException {
      throw const BookApiException(
        'A busca demorou demais. Verifique sua conexão e tente novamente.',
      );
    } on BookApiException {
      rethrow;
    } on http.ClientException {
      throw const BookApiException(
        'Não foi possível acessar a internet. Verifique sua conexão.',
      );
    } on FormatException {
      throw const BookApiException(
        'Não foi possível interpretar os dados retornados pela API.',
      );
    } catch (_) {
      throw const BookApiException(
        'Ocorreu um erro inesperado durante a busca.',
      );
    }
  }

  void dispose() {
    _client.close();
  }
}

class BookApiException implements Exception {
  const BookApiException(this.message);

  final String message;

  @override
  String toString() => message;
}