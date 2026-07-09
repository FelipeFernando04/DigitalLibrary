import '../models/book.dart';
import '../services/book_api_service.dart';
import '../services/local_storage_service.dart';

class BookRepository {
  BookRepository({
    BookApiService? apiService,
    LocalStorageService? localStorageService,
  })  : _apiService = apiService ?? BookApiService(),
        _localStorageService =
            localStorageService ?? LocalStorageService();

  final BookApiService _apiService;
  final LocalStorageService _localStorageService;

  Future<List<Book>> searchBooks(String query) {
    return _apiService.searchBooks(query);
  }

  Future<List<Book>> loadFavorites() {
    return _localStorageService.loadFavorites();
  }

  Future<void> saveFavorites(List<Book> books) {
    return _localStorageService.saveFavorites(books);
  }

  void dispose() {
    _apiService.dispose();
  }
}