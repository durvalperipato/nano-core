import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:nano_core/nano_core.dart';

class TestPageState extends NanoViewState {
  const TestPageState({required this.title});
  final String title;

  @override
  List<Object?> get props => [title];
}

class TestPageController extends NanoController<TestPageState> {
  TestPageController()
    : super(initialState: const TestPageState(title: 'initial'));

  bool initCalled = false;
  String? passedId;

  @override
  Future<void> init(String? id) async {
    initCalled = true;
    passedId = id;
  }
}

class TestInjections extends NanoInjections {
  const TestInjections() : super(scope: 'test_page_scope');

  @override
  void binds(GetIt i) {
    i.registerFactory<TestPageController>(TestPageController.new);
  }
}

class TestPageWidget extends StatefulWidget {
  const TestPageWidget({super.key});

  @override
  State<TestPageWidget> createState() => _TestPageWidgetState();
}

class _TestPageWidgetState
    extends NanoStatePage<TestPageWidget, TestPageController> {
  @override
  NanoInjections get injections => const TestInjections();

  @override
  String? get id => 'custom-id-123';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text(
        'Initialized: ${controller.initCalled} - ${controller.passedId}',
      ),
    );
  }
}

void main() {
  group('NanoStatePage', () {
    tearDown(() async {
      await GetIt.I.reset();
    });

    testWidgets(
      'initializes scope, retrieves controller, calls init and disposes scope',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: TestPageWidget(),
          ),
        );

        expect(find.text('Initialized: true - custom-id-123'), findsOneWidget);

        // Verify scope exists while widget is mounted
        expect(GetIt.I.hasScope('test_page_scope'), isTrue);

        // Unmount widget
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pumpAndSettle();

        // Verify scope was dropped on dispose
        expect(GetIt.I.hasScope('test_page_scope'), isFalse);
      },
    );
  });
}
