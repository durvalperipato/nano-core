import 'package:flutter_test/flutter_test.dart';
import 'package:nano_core/nano_core.dart';

class LoginFormEntity extends NanoFormEntity {
  const LoginFormEntity({this.email = '', this.password = ''});

  final String email;
  final String password;

  LoginFormEntity copyWith({String? email, String? password}) {
    return LoginFormEntity(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  @override
  List<Object?> get props => [email, password];
}

class LoginFormState extends NanoFormState<LoginFormEntity> {
  const LoginFormState({
    super.form = const LoginFormEntity(),
    this.isSubmitting = false,
  });

  final bool isSubmitting;

  @override
  List<Object?> get props => [form, isSubmitting];
}

class LoginFormController
    extends NanoFormController<LoginFormState, LoginFormEntity> {
  LoginFormController() : super(initialState: const LoginFormState());
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('NanoFormController', () {
    test('initializes with currentForm', () {
      final controller = LoginFormController();
      expect(controller.currentForm?.email, isEmpty);
      expect(controller.currentForm?.password, isEmpty);
    });

    test('updateForm modifies state and emits update', () {
      final controller = LoginFormController();
      var notifications = 0;
      controller
        ..addListener(() => notifications++)
        ..updateForm(
          (current) => LoginFormState(
            form: current.form.copyWith(
              email: 'user@test.com',
            ),
          ),
        );

      expect(notifications, 1);
      expect(controller.currentForm?.email, 'user@test.com');
    });

    test('reset restores initial state', () {
      final controller = LoginFormController()
        ..updateForm(
          (current) => LoginFormState(
            form: current.form.copyWith(
              email: 'modified@test.com',
            ),
          ),
        );
      expect(controller.currentForm?.email, 'modified@test.com');

      controller.reset();
      expect(controller.currentForm?.email, isEmpty);
      expect(controller.hasUnsavedChanges, isFalse);
      controller.dispose();
    });

    test(
      'hasUnsavedChanges compares form value equality and ignores view flags',
      () {
        final controller = LoginFormController();
        expect(controller.hasUnsavedChanges, isFalse);

        controller.updateForm(
          (current) => LoginFormState(form: current.form, isSubmitting: true),
        );
        expect(controller.hasUnsavedChanges, isFalse);

        controller.updateForm(
          (current) => LoginFormState(
            form: current.form.copyWith(email: 'dirty@test.com'),
          ),
        );
        expect(controller.hasUnsavedChanges, isTrue);

        controller.updateForm(
          (current) => LoginFormState(
            form: current.form.copyWith(email: ''),
          ),
        );
        expect(controller.hasUnsavedChanges, isFalse);
        controller.dispose();
      },
    );

    test(
      'loadForm updates baselineState, baselineForm, and reset target',
      () {
        final controller = LoginFormController();
        const loadedEntity = LoginFormEntity(
          email: 'saved@test.com',
          password: 'secret',
        );

        controller.loadForm(
          (_) => const LoginFormState(form: loadedEntity),
        );

        expect(controller.baselineForm, equals(loadedEntity));
        expect(controller.baselineState.form, equals(loadedEntity));
        expect(controller.currentForm, equals(loadedEntity));
        expect(controller.hasUnsavedChanges, isFalse);

        controller.updateForm(
          (current) => LoginFormState(
            form: current.form.copyWith(email: 'edited@test.com'),
          ),
        );
        expect(controller.hasUnsavedChanges, isTrue);

        controller.reset();
        expect(controller.currentForm, equals(loadedEntity));
        expect(controller.baselineForm, equals(loadedEntity));
        expect(controller.hasUnsavedChanges, isFalse);
        controller.dispose();
      },
    );
  });
}
