import 'mock_models.dart';

class MockApi {
  static Future<MockUser> fetchUser() async {
    await Future.delayed(const Duration(seconds: 2));
    return const MockUser(id: '1', name: 'John Doe', email: 'john@example.com');
  }

  static Future<List<MockCompany>> fetchCompanies() async {
    await Future.delayed(const Duration(seconds: 3));
    return const [
      MockCompany(id: '1', name: 'Nano Corp'),
      MockCompany(id: '2', name: 'Flutter Giga'),
      MockCompany(id: '3', name: 'Dart Master'),
    ];
  }
}
