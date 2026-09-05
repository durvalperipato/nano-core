import 'package:flutter_test/flutter_test.dart';
import 'package:nano_core/nano_core.dart';

class Customer {
  const Customer({required this.id, required this.email});
  final String id;
  final String email;
}

class CustomerAdapter extends NanoAdapter<Customer> {
  const CustomerAdapter();

  @override
  Customer fromMap(Map<String, dynamic> map) => Customer(
    id: map['id'] as String,
    email: map['email'] as String,
  );

  @override
  Map<String, dynamic> toMap(Customer entity) => {
    'id': entity.id,
    'email': entity.email,
  };
}

void main() {
  group('NanoAdapter', () {
    const adapter = CustomerAdapter();

    test('combines read and write capabilities correctly', () {
      const original = Customer(id: 'c1', email: 'test@example.com');
      final map = adapter.toMap(original);
      expect(map, {'id': 'c1', 'email': 'test@example.com'});

      final reconstructed = adapter.fromMap(map);
      expect(reconstructed.id, original.id);
      expect(reconstructed.email, original.email);
    });
  });
}
