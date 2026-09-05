import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nano_core/nano_core.dart';

void main() {
  group('NanoCommandBuilder', () {
    testWidgets('renders different states as command executes', (
      tester,
    ) async {
      final command = NanoCommand1<String, String>(
        (arg) async {
          if (arg == 'error') {
            throw Exception('Command error');
          }
          return 'Result: $arg';
        },
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NanoCommandBuilder<String>(
              command: command,
              builder: (context, state) {
                return switch (state) {
                  InitialState() => const Text('INITIAL'),
                  LoadingState() => const Text('LOADING'),
                  LoadedState(:final data) => Text('SUCCESS: $data'),
                  ErrorState() => const Text('ERROR'),
                  _ => const Text('OTHER'),
                };
              },
            ),
          ),
        ),
      );

      expect(find.text('INITIAL'), findsOneWidget);

      await command.run('hello');
      await tester.pump();
      expect(find.text('SUCCESS: Result: hello'), findsOneWidget);

      await command.run('error');
      await tester.pump();
      expect(find.text('ERROR'), findsOneWidget);

      command.dispose();
    });
  });
}
