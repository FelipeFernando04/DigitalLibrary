import 'package:flutter/material.dart';

import '../../models/book.dart';
import '../../repositories/book_repository.dart';
import '../../widgets/error_view.dart';
import '../../widgets/loading_view.dart';
import '../favorites/favorites_screen.dart';
import '../home/home_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late final BookRepository _repository;

  int _selectedIndex = 0;
  List<Book> _favorites = const [];
  bool _isLoadingFavorites = true;
  String? _favoritesLoadError;

  @override
  void initState() {
    super.initState();
    _repository = BookRepository();
    _loadFavorites();
  }

  @override
  void dispose() {
    _repository.dispose();
    super.dispose();
  }

  Future<void> _loadFavorites() async {
    setState(() {
      _isLoadingFavorites = true;
      _favoritesLoadError = null;
    });

    try {
      final favorites = await _repository.loadFavorites();

      if (!mounted) return;

      setState(() {
        _favorites = favorites;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _favoritesLoadError =
            'Não foi possível carregar os favoritos salvos.';
      });
    } finally {
      if (mounted) {
        setState(() => _isLoadingFavorites = false);
      }
    }
  }

  Future<void> _toggleFavorite(Book book) async {
    final alreadyFavorite = _favorites.any(
      (favorite) => favorite.id == book.id,
    );

    final updated = alreadyFavorite
        ? _favorites
            .where((favorite) => favorite.id != book.id)
            .toList()
        : [..._favorites, book];

    try {
      await _repository.saveFavorites(updated);

      if (!mounted) return;

      setState(() {
        _favorites = updated;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            alreadyFavorite
                ? 'Livro removido dos favoritos.'
                : 'Livro adicionado aos favoritos.',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Não foi possível salvar a alteração nos favoritos.',
          ),
        ),
      );

      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingFavorites) {
      return const Scaffold(
        body: SafeArea(
          child: LoadingView(
            message: 'Carregando sua biblioteca...',
          ),
        ),
      );
    }

    if (_favoritesLoadError != null) {
      return Scaffold(
        body: SafeArea(
          child: ErrorView(
            message: _favoritesLoadError!,
            onRetry: _loadFavorites,
          ),
        ),
      );
    }

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomeScreen(
            repository: _repository,
            favorites: _favorites,
            onToggleFavorite: _toggleFavorite,
          ),
          FavoritesScreen(
            favorites: _favorites,
            onToggleFavorite: _toggleFavorite,
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
            label: 'Buscar',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
        ],
      ),
    );
  }
}