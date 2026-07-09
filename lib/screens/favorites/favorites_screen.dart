import 'package:flutter/material.dart';
import '../../models/book.dart';
import '../../widgets/book_card.dart';
import '../../widgets/empty_state.dart';
import '../details/book_details_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({
    super.key,
    required this.favorites,
    required this.onToggleFavorite,
  });

  final List<Book> favorites;
  final Future<void> Function(Book book) onToggleFavorite;

  void _openDetails(BuildContext context, Book book) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BookDetailsScreen(
          book: book,
          isFavorite: true,
          onToggleFavorite: onToggleFavorite,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Meus favoritos',
                  style:
                      Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                ),
                const SizedBox(height: 4),
                Text(
                  favorites.isEmpty
                      ? 'Sua estante pessoal está vazia.'
                      : '${favorites.length} livro(s) salvo(s) neste dispositivo.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color:
                            Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: favorites.isEmpty
                      ? const EmptyState(
                          icon: Icons.favorite_border,
                          title: 'Nenhum favorito ainda',
                          message:
                              'Favorite livros na busca ou na tela de detalhes para encontrá-los aqui depois.',
                        )
                      : ListView.separated(
                          itemCount: favorites.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final book = favorites[index];

                            return BookCard(
                              book: book,
                              isFavorite: true,
                              onTap: () => _openDetails(context, book),
                              onToggleFavorite: () =>
                                  onToggleFavorite(book),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}