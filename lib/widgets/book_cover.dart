import 'package:flutter/material.dart';

import '../models/book.dart';

class BookCover extends StatelessWidget {
  const BookCover({
    super.key,
    required this.book,
    this.width = 82,
    this.height = 116,
  });

  final Book book;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final url = book.coverUrl;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: width,
        height: height,
        child: url == null
            ? _FallbackCover(title: book.title)
            : Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return _FallbackCover(title: book.title);
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;

                  return Container(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    alignment: Alignment.center,
                    child: const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2.5),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class _FallbackCover extends StatelessWidget {
  const _FallbackCover({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primaryContainer,
      padding: const EdgeInsets.all(10),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.menu_book_rounded,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            size: 30,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
          ),
        ],
      ),
    );
  }
}