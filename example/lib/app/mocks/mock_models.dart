import 'package:nano_core/nano_core.dart';

class MockUser extends NanoEntity<String> {
  final String name;
  final String email;
  final String role;

  const MockUser({
    required super.id,
    required this.name,
    required this.email,
    this.role = 'user',
  });

  @override
  List<Object?> get props => [id, name, email, role];

  @override
  String toString() => 'User(id: $id, name: $name, email: $email, role: $role)';
}

class MockUserAdapter extends NanoAdapter<MockUser> {
  const MockUserAdapter();

  @override
  MockUser fromMap(Map<String, dynamic> map) {
    return MockUser(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      role: map['role'] as String? ?? 'user',
    );
  }

  @override
  Map<String, dynamic> toMap(MockUser model) {
    return {
      'id': model.id,
      'name': model.name,
      'email': model.email,
      'role': model.role,
    };
  }
}

class MockUserRepository extends NanoRepository<MockUser, String> {
  MockUserRepository([NanoHttpClient? client])
      : super(
          endpoint: '/users',
          adapter: const MockUserAdapter(),
          client: client,
        );
}

class MockUserFilter {
  final String? name;
  final String? role;

  const MockUserFilter({this.name, this.role});
}

class MockUserFilterAdapter extends NanoWriteAdapter<MockUserFilter> {
  const MockUserFilterAdapter();

  @override
  Map<String, dynamic> toMap(MockUserFilter query) {
    return <String, dynamic>{}
        .addIf('name', query.name)
        .addIf('role', query.role, condition: query.role != 'all');
  }
}

class MockUserSearchRepository
    extends NanoSearchRepository<MockUser, String, MockUserFilter> {
  MockUserSearchRepository([NanoHttpClient? client])
      : super(
          endpoint: '/users',
          adapter: const MockUserAdapter(),
          queryAdapter: const MockUserFilterAdapter(),
          client: client,
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

