import 'package:nano_core/nano_core.dart';

class MockUser extends NanoEquatable {
  final String id;
  final String name;
  final String email;

  const MockUser({required this.id, required this.name, required this.email});

  @override
  List<Object?> get props => [id, name, email];

  @override
  String toString() => 'User(id: $id, name: $name, email: $email)';
}

class MockCompany extends NanoEquatable {
  final String id;
  final String name;

  const MockCompany({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];

  @override
  String toString() => 'Company(id: $id, name: $name)';
}
