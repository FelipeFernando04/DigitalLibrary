import 'package:digital_library/models/book.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Book', () {
    test('converte resposta da Open Library em objeto', () {
      final book = Book.fromOpenLibraryJson({
        'key': '/works/OL123W',
        'title': 'Livro de Teste',
        'author_name': ['Autor Exemplo'],
        'cover_i': 12345,
        'first_publish_year': 2020,
        'publisher': ['Editora Exemplo'],
        'language': ['por'],
        'subject': ['Tecnologia', 'Educação'],
      });

      expect(book.id, '/works/OL123W');
      expect(book.title, 'Livro de Teste');
      expect(book.authorsText, 'Autor Exemplo');
      expect(book.firstPublishYear, 2020);
      expect(book.coverUrl, contains('12345'));
    });

    test('mantém dados ao converter para JSON e voltar', () {
      const original = Book(
        id: '1',
        title: 'Persistência',
        authors: ['Autor'],
        summary: 'Resumo',
        firstPublishYear: 2024,
        languages: ['por'],
      );

      final restored = Book.fromJson(original.toJson());

      expect(restored.id, original.id);
      expect(restored.title, original.title);
      expect(restored.authors, original.authors);
      expect(restored.firstPublishYear, 2024);
    });
  });
}