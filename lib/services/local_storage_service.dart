import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/book.dart';
import '../utils/app_constants.dart';

class LocalStorageService {
  LocalStorageService({SharedPreferencesAsync? preferences})
      : _preferences = preferences ?? SharedPreferencesAsync();

  final SharedPreferencesAsync _preferences;

  Future<List<Book>> loadFavorites() async {
    final encodedBooks = await _preferences.getStringList(
      AppConstants.favoritesStorageKey,
    );

    if (encodedBooks == null) {
      return const [];
    }

    final books = <Book>[];

    for (final encodedBook in encodedBooks) {
      try {
        final decoded = jsonDecode(encodedBook);
        if (decoded is Map<String, dynamic>) {
          books.add(Book.fromJson(decoded));
        } else if (decoded is Map) {
          books.add(
            Book.fromJson(Map<String, dynamic>.from(decoded)),
          );
        }
      } catch (_) {
        // Um item inválido não impede o carregamento dos demais favoritos.
      }
    }

    return books;
  }

  Future<void> saveFavorites(List<Book> books) async {
    final encodedBooks = books
        .map((book) => jsonEncode(book.toJson()))
        .toList(growable: false);

    await _preferences.setStringList(
      AppConstants.favoritesStorageKey,
      encodedBooks,
    );
  }
}