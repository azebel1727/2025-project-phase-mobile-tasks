// test/features/product/data/models/product_model_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:task6/features/product/data/models/product_model.dart';

void main() {
  const productJson = {
    'id': '1',
    'name': 'Derby Shoes',
    'description': 'Classic leather shoes',
    'imageUrl': 'assets/image.jpg',
    'price': 120.0,
  };

  const model = ProductModel(
    id: '1',
    name: 'Derby Shoes',
    description: 'Classic leather shoes',
    imageUrl: 'assets/image.jpg',
    price: 120.0,
  );

  test('should convert JSON to ProductModel', () {
    final result = ProductModel.fromJson(productJson);
    expect(result, equals(model));
  });

  test('should convert ProductModel to JSON', () {
    final result = model.toJson();
    expect(result, equals(productJson));
  });
}
