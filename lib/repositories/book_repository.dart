import '../models/book.dart';
import '../services/book_api_service.dart';

class BookRepository {
  BookRepository({BookApiService? apiService})
      : _apiService = apiService ?? BookApiService();

  final BookApiService _apiService;

  Future<List<Book>> searchBooks(String query) {
    return _apiService.searchBooks(query);
  }

  void dispose() {
    _apiService.dispose();
  }
}