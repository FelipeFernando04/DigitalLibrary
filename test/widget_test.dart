import 'package:digital_library/widgets/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('EmptyState exibe título e mensagem', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: EmptyState(
            icon: Icons.info_outline,
            title: 'Título de teste',
            message: 'Mensagem de teste',
          ),
        ),
      ),
    );

    expect(find.text('Título de teste'), findsOneWidget);
    expect(find.text('Mensagem de teste'), findsOneWidget);
  });
}