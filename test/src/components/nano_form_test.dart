import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nano_core/nano_core.dart';

class SampleFormEntity extends NanoFormEntity {
  const SampleFormEntity({this.text = ''});
  final String text;

  @override
  List<Object?> get props => [text];
}

class SampleFormState extends NanoFormState<SampleFormEntity> {
  const SampleFormState({super.form = const SampleFormEntity()});

  @override
  List<Object?> get props => [form];
}

class SampleFormController
    extends NanoFormController<SampleFormState, SampleFormEntity> {
  SampleFormController() : super(initialState: const SampleFormState());
}

void main() {
  group('NanoForm Widget', () {
    testWidgets('binds controller.formKey and renders child subtree', (
      tester,
    ) async {
      final controller = SampleFormController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NanoForm(
              controller: controller,
              child: const Text('Inside Form'),
            ),
          ),
        ),
      );

      expect(find.text('Inside Form'), findsOneWidget);
      expect(controller.formKey.currentState, isNotNull);
    });
  });
}
