git add lib/services/local_storage_service.dartimport 'package:flutter/material.dart';

import '../../models/book.dart';
import '../../utils/app_constants.dart';
import '../../widgets/book_cover.dart';

class BookDetailsScreen extends StatefulWidget {
  const BookDetailsScreen({
    super.key,
    required this.book,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  final Book book;
  final bool isFavorite;
  final Future<void> Function(Book book) onToggleFavorite;

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  late bool _isFavorite;
  bool _isUpdatingFavorite = false;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
  }

  Future<void> _toggleFavorite() async {
    if (_isUpdatingFavorite) return;

    setState(() => _isUpdatingFavorite = true);

    try {
      await widget.onToggleFavorite(widget.book);

      if (!mounted) return;
      setState(() => _isFavorite = !_isFavorite);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Não foi possível atualizar os favoritos.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isUpdatingFavorite = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final book = widget.book;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do livro'),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 700;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 960),
                  child: isWide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BookCover(
                              book: book,
                              width: 220,
                              height: 320,
                            ),
                            const SizedBox(width: 32),
                            Expanded(child: _buildDetails(theme)),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Align(
                              child: BookCover(
                                book: book,
                                width: 190,
                                height: 276,
                              ),
                            ),
                            const SizedBox(height: 26),
                            _buildDetails(theme),
                          ],
                        ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDetails(ThemeData theme) {
    final book = widget.book;
    final publisher = book.publishers.isEmpty
        ? 'Não informada'
        : book.publishers.take(3).join(', ');
    final languages = book.languages.isEmpty
        ? 'Não informado'
        : book.languages
            .take(4)
            .map(AppConstants.languageLabel)
            .join(', ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          book.title,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w900,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          book.authorsText,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 22),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: _isUpdatingFavorite ? null : _toggleFavorite,
            icon: _isUpdatingFavorite
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : Icon(
                    _isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                  ),
            label: Text(
              _isFavorite
                  ? 'Remover dos favoritos'
                  : 'Adicionar aos favoritos',
            ),
          ),
        ),
        const SizedBox(height: 28),
        Text(
          'Sobre o livro',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          book.summary,
          style: theme.textTheme.bodyLarge?.copyWith(
            height: 1.55,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 28),
        _InfoRow(
          icon: Icons.calendar_today_outlined,
          label: 'Primeira publicação',
          value: book.firstPublishYear?.toString() ?? 'Não informada',
        ),
        _InfoRow(
          icon: Icons.apartment_outlined,
          label: 'Editora',
          value: publisher,
        ),
        _InfoRow(
          icon: Icons.language_outlined,
          label: 'Idioma',
          value: languages,
        ),
        if (book.subjects.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            'Temas',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: book.subjects
                .take(8)
                .map((subject) => Chip(label: Text(subject)))
                .toList(),
          ),
        ],
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 22,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}