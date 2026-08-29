import 'package:nano_core/nano_core.dart';

class MockUser extends NanoEntity<String> {
  final String name;
  final String email;

  const MockUser({
    required super.id,
    required this.name,
    required this.email,
  });

  @override
  List<Object?> get props => [id, name, email];

  @override
  String toString() => 'User(id: $id, name: $name, email: $email)';
}

class MockUserAdapter implements NanoAdapter<MockUser> {
  const MockUserAdapter();

  @override
  MockUser fromJson(Map<String, dynamic> json) {
    return MockUser(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson(MockUser model) {
    return {
      'id': model.id,
      'name': model.name,
      'email': model.email,
    };
  }
}

class MockUserRepository extends NanoRepository<MockUser, String> {
  MockUserRepository(NanoHttpClient client)
      : super(
          client: client,
          endpoint: '/users',
          adapter: const MockUserAdapter(),
        );
}

class MockCompany extends NanoEntity<String> {
  final String name;

  const MockCompany({
    required super.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];

  @override
  String toString() => 'Company(id: $id, name: $name)';
}

