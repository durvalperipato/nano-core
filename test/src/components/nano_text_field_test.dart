import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nano_core/nano_core.dart';

void main() {
  group('NanoTextField Widget', () {
    testWidgets('renders initial value and triggers onChanged', (tester) async {
      String? updatedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NanoTextField(
              value: 'Initial text',
              label: 'Username',
              onChanged: (val) => updatedValue = val,
            ),
          ),
        ),
      );

      expect(find.text('Initial text'), findsOneWidget);
      expect(find.text('Username'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'New text');
      expect(updatedValue, 'New text');
    });

    testWidgets('evaluates validation errors on submit', (tester) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: NanoTextField(
                validators: [
                  NanoValidator.required('This field cannot be empty'),
                ],
              ),
            ),
          ),
        ),
      );

      formKey.currentState?.validate();
      await tester.pump();

      expect(find.text('This field cannot be empty'), findsOneWidget);
    });

    testWidgets('password mode toggles obscure text visibility', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: NanoTextField(
              value: 'secret123',
              isPassword: true,
            ),
          ),
        ),
      );

      final textFieldFinder = find.byType(TextField);
      TextField textField = tester.widget(textFieldFinder);
      expect(textField.obscureText, isTrue);

      // Tap visibility toggle button
      await tester.tap(find.byType(IconButton));
      await tester.pump();

      textField = tester.widget(textFieldFinder);
      expect(textField.obscureText, isFalse);
    });
  });
}
