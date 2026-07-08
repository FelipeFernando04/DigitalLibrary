import 'package:flutter/material.dart';

import '../../utils/app_constants.dart';
import '../../widgets/empty_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
              'Descubra sua próxima leitura.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 22),
            const TextField(
              enabled: false,
              decoration: InputDecoration(
                hintText: 'Buscar por título, autor ou palavra-chave',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 16),
            const Expanded(
              child: EmptyState(
                icon: Icons.auto_stories_outlined,
                title: 'Estrutura base pronta',
                message:
                    'A busca de livros será integrada no próximo Pull Request.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}