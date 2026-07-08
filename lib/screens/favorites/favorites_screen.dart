import 'package:flutter/material.dart';

import '../../widgets/empty_state.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: EmptyState(
        icon: Icons.favorite_border,
        title: 'Nenhum favorito ainda',
        message:
            'A persistência local de livros será adicionada em um Pull Request específico.',
      ),
    );
  }
}