import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task6/features/product/data/datasources/product_local_datasource_impl.dart';
import 'package:task6/features/product/data/models/product_model.dart';

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

  final productList = [productModel];
  final cachedJson = json.encode(productList.map((p) => p.toJson()).toList());

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

  group('getLastCachedProducts', () {
    test('should return list of products from SharedPreferences', () async {
      when(mockSharedPreferences.getString(any)).thenReturn(cachedJson);

      final result = await datasource.getLastCachedProducts();

      expect(result, equals(productList));
    });

    test('should throw Exception when no cached data', () {
      when(mockSharedPreferences.getString(any)).thenReturn(null);

      expect(() => datasource.getLastCachedProducts(), throwsException);
    });
  });
}
