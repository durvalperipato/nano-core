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

class MockUserAdapter implements NanoAdapter<MockUser> {
  const MockUserAdapter();

  @override
  MockUser fromJson(Map<String, dynamic> json) {
    return MockUser(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      role: json['role'] as String? ?? 'user',
    );
  }

  @override
  Map<String, dynamic> toJson(MockUser model) {
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

class MockUserFilterAdapter extends NanoQueryAdapter<MockUserFilter> {
  const MockUserFilterAdapter();

  @override
  Map<String, dynamic> toQueryParams(MockUserFilter query) {
    return {
      if (query.name != null) 'name': query.name,
      if (query.role != null) 'role': query.role,
    };
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

