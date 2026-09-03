import 'package:flutter/material.dart';
import 'package:nano_core/nano_core.dart';
import 'section_header.dart';

/// Form data entity holding user inputs.
class UserFormEntity extends NanoFormEntity {
  const UserFormEntity({this.name = '', this.email = '', this.password = ''});

  final String name;
  final String email;
  final String password;

  UserFormEntity copyWith({
    String Function()? name,
    String Function()? email,
    String Function()? password,
  }) {
    return UserFormEntity(
      name: name != null ? name() : this.name,
      email: email != null ? email() : this.email,
      password: password != null ? password() : this.password,
    );
  }

  @override
  List<Object?> get props => [name, email, password];
}

/// View state holding the [UserFormEntity].
class RegisterFormState extends NanoFormState<UserFormEntity> {
  const RegisterFormState({super.form = const UserFormEntity()});

  RegisterFormState copyWith({UserFormEntity? form}) {
    return RegisterFormState(form: form ?? this.form);
  }
}

/// Controller managing the [RegisterFormState].
class RegisterFormController
    extends NanoFormController<RegisterFormState, UserFormEntity> {
  RegisterFormController() : super(initialState: const RegisterFormState());
}

/// Card showcasing [NanoFormEntity], [NanoFormState], [NanoFormController], and [NanoTextField].
class FormShowcaseCard extends StatefulWidget {
  /// Creates a [FormShowcaseCard] widget.
  const FormShowcaseCard({super.key});

  @override
  State<FormShowcaseCard> createState() => _FormShowcaseCardState();
}

class _FormShowcaseCardState extends State<FormShowcaseCard> {
  late final RegisterFormController _controller;
  String _submittedData = '';

  @override
  void initState() {
    super.initState();
    _controller = RegisterFormController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    _controller.submit(
      (form) {
        setState(() {
          _submittedData =
              '✅ Form Submitted:\nName: ${form.name}\nEmail: ${form.email}';
        });
        NanoToast.showSuccess(context, 'Form submitted successfully!');
      },
      onInvalid: () {
        setState(() {
          _submittedData = '❌ Form has validation errors.';
        });
        NanoToast.showWarning(context, 'Please fix validation errors.');
      },
    );
  }

  void _handleReset() {
    _controller.reset();
    setState(() {
      _submittedData = '';
    });
    NanoToast.showSuccess(context, 'Form fields reset.');
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              icon: Icons.edit_note_outlined,
              title: 'Form State Management (NanoFormEntity)',
              subtitle:
                  'Immutable form entities, NanoFormController, and reactive NanoTextField',
            ),
            const SizedBox(height: 16),

            ListenableBuilder(
              listenable: _controller,
              builder: (context, _) {
                final form = _controller.currentForm ?? const UserFormEntity();

                return NanoForm(
                  controller: _controller,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Form inputs
                      NanoTextField(
                        value: form.name,
                        label: 'Full Name',
                        hint: 'e.g. John Doe',
                        prefixIcon: const Icon(Icons.person_outline),
                        validators: [
                          NanoValidator.required('Name is required'),
                          NanoValidator.minLength(3, 'Minimum 3 characters'),
                        ],
                        onChanged: (text) => _controller.updateForm(
                          (state) => state.copyWith(
                            form: state.form.copyWith(name: () => text),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      NanoTextField(
                        value: form.email,
                        label: 'Email Address',
                        hint: 'e.g. john@example.com',
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(Icons.email_outlined),
                        validators: [
                          NanoValidator.required('Email is required'),
                          NanoValidator.email(
                            'Please enter a valid email address',
                          ),
                        ],
                        onChanged: (text) => _controller.updateForm(
                          (state) => state.copyWith(
                            form: state.form.copyWith(email: () => text),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      NanoTextField(
                        value: form.password,
                        label: 'Password',
                        isPassword: true,
                        prefixIcon: const Icon(Icons.lock_outline),
                        validators: [
                          NanoValidator.required('Password is required'),
                          NanoValidator.minLength(6, 'Minimum 6 characters'),
                        ],
                        onChanged: (text) => _controller.updateForm(
                          (state) => state.copyWith(
                            form: state.form.copyWith(password: () => text),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          FilledButton.icon(
                            icon: const Icon(Icons.check, size: 18),
                            label: const Text('Submit Form'),
                            onPressed: _handleSubmit,
                          ),
                          OutlinedButton.icon(
                            icon: const Icon(Icons.restart_alt, size: 18),
                            label: const Text('Reset Form'),
                            onPressed: _handleReset,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),

            if (_submittedData.isNotEmpty) ...[
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: SelectableText(
                  _submittedData,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    color: _submittedData.contains('✅')
                        ? const Color(0xFF10B981)
                        : const Color(0xFFEF4444),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
