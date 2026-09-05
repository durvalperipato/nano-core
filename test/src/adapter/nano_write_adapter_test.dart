import 'package:flutter_test/flutter_test.dart';
import 'package:nano_core/nano_core.dart';

class Product {
  const Product({required this.sku, required this.price});
  final String sku;
  final double price;
}

class ProductWriteAdapter with NanoWriteAdapter<Product> {
  const ProductWriteAdapter();

  @override
  Map<String, dynamic> toMap(Product entity) => {
    'sku': entity.sku,
    'price': entity.price,
  };
}

void main() {
  group('NanoWriteAdapter', () {
    const adapter = ProductWriteAdapter();

    test('toMap serializes entity to map', () {
      final map = adapter.toMap(const Product(sku: 'P100', price: 29.9));
      expect(map, {'sku': 'P100', 'price': 29.9});
    });

    test('toList serializes list of entities', () {
      final list = adapter.toList([
        const Product(sku: 'P1', price: 10.0),
        const Product(sku: 'P2', price: 20.0),
      ]);

      expect(list.length, 2);
      expect(list[0], {'sku': 'P1', 'price': 10.0});
      expect(list[1], {'sku': 'P2', 'price': 20.0});
    });

    test('toList returns empty list when null', () {
      expect(adapter.toList(null), isEmpty);
    });
  });
}
