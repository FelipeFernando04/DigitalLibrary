import 'package:flutter/material.dart';

import '../../models/book.dart';
import '../../repositories/book_repository.dart';
import '../../services/book_api_service.dart';
import '../../utils/app_constants.dart';
import '../../widgets/book_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_view.dart';
import '../../widgets/loading_view.dart';
import '../details/book_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.repository,
    required this.favorites,
    required this.onToggleFavorite,
  });

  final BookRepository repository;
  final List<Book> favorites;
  final Future<void> Function(Book book) onToggleFavorite;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();

  List<Book> _books = const [];
  bool _isLoading = false;
  bool _hasSearched = false;
  String? _errorMessage;
  String? _validationMessage;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _isFavorite(Book book) {
    return widget.favorites.any((favorite) => favorite.id == book.id);
  }

  Future<void> _search() async {
    final query = _searchController.text.trim();

    if (query.isEmpty) {
      setState(() {
        _validationMessage =
            'Digite um título, autor ou palavra-chave para pesquisar.';
      });
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
      _hasSearched = true;
      _errorMessage = null;
      _validationMessage = null;
    });

    try {
      final books = await widget.repository.searchBooks(query);

      if (!mounted) return;

      setState(() {
        _books = books;
      });
    } on BookApiException catch (error) {
      if (!mounted) return;
      setState(() => _errorMessage = error.message);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Ocorreu um erro inesperado. Tente novamente.';
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _books = const [];
      _hasSearched = false;
      _errorMessage = null;
      _validationMessage = null;
    });
  }

  void _openDetails(Book book) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BookDetailsScreen(
          book: book,
          isFavorite: _isFavorite(book),
          onToggleFavorite: widget.onToggleFavorite,
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
                  AppConstants.appName,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Pesquise por título, autor ou palavra-chave.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color:
                            Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _searchController,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (_) => _search(),
                  decoration: InputDecoration(
                    hintText: 'Ex.: Machado de Assis, Flutter, Clean Code',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'Limpar busca',
                            onPressed: _clearSearch,
                            icon: const Icon(Icons.close),
                          ),
                    errorText: _validationMessage,
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _isLoading ? null : _search,
                    icon: const Icon(Icons.travel_explore),
                    label: const Text('Buscar livros'),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(child: _buildContent()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const LoadingView();
    }

    if (_errorMessage != null) {
      return ErrorView(
        message: _errorMessage!,
        onRetry: _search,
      );
    }

    if (!_hasSearched) {
      return const EmptyState(
        icon: Icons.auto_stories_outlined,
        title: 'Encontre sua próxima leitura',
        message:
            'Use a busca acima para consultar livros disponíveis na Open Library.',
      );
    }

    if (_books.isEmpty) {
      return const EmptyState(
        icon: Icons.search_off,
        title: 'Nenhum livro encontrado',
        message:
            'Tente outro título, autor ou uma palavra-chave diferente.',
      );
    }

    return ListView.separated(
      itemCount: _books.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final book = _books[index];

        return BookCard(
          book: book,
          isFavorite: _isFavorite(book),
          onTap: () => _openDetails(book),
          onToggleFavorite: () => widget.onToggleFavorite(book),
        );
      },
    );
  }
}