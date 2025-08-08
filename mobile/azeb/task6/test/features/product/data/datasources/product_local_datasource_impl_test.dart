import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task6/features/product/data/datasources/product_local_datasource_impl.dart';
import 'package:task6/features/product/data/models/product_model.dart';
import 'package:task6/domain/entities/product.dart';

@GenerateMocks([SharedPreferences])
import 'product_local_datasource_impl_test.mocks.dart';

void main() {
  late ProductLocalDatasourceImpl datasource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    datasource = ProductLocalDatasourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  final productModel = ProductModel(
    id: '1',
    name: 'Product A',
    description: 'A great product',
    imageUrl: 'https://example.com/image.png',
    price: 20,
  );

  // Convert ProductModel to Product entity for local datasource methods
  final productEntity = Product(
    id: productModel.id,
    name: productModel.name,
    description: productModel.description,
    price: productModel.price,
    imageUrl: productModel.imageUrl,
  );

  final productList = [productEntity];

  // Manually encode JSON as local datasource expects
  final cachedJson = json.encode(
    productList
        .map(
          (p) => {
            'id': p.id,
            'name': p.name,
            'description': p.description,
            'price': p.price,
            'imageUrl': p.imageUrl,
          },
        )
        .toList(),
  );

  group('cacheProducts', () {
    test('should call SharedPreferences to cache the data', () async {
      when(
        mockSharedPreferences.setString(any, any),
      ).thenAnswer((_) async => true);

      await datasource.cacheProducts(productList);

      verify(
        mockSharedPreferences.setString(cachedProductsKey, cachedJson),
      ).called(1);
    });
  });

  group('getCachedProducts', () {
    test('should return list of products from SharedPreferences', () async {
      when(mockSharedPreferences.getString(any)).thenReturn(cachedJson);

      final result = await datasource.getCachedProducts();

      expect(result, equals(productList));
    });

    test('should throw Exception when no cached data', () {
      when(mockSharedPreferences.getString(any)).thenReturn(null);

      expect(() => datasource.getCachedProducts(), throwsException);
    });
  });

  group('getCachedProductById', () {
    test('should return product when found in cache', () async {
      when(mockSharedPreferences.getString(any)).thenReturn(cachedJson);

      final result = await datasource.getCachedProductById('1');

      expect(result, isNotNull);
      expect(result?.id, '1');
    });

    test('should return null when product not found', () async {
      when(mockSharedPreferences.getString(any)).thenReturn(cachedJson);

      final result = await datasource.getCachedProductById('non-existent-id');

      expect(result, isNull);
    });
  });
}
