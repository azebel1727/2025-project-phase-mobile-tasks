import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:task6/features/product/data/datasources/product_remote_datasource_impl.dart';
import 'package:task6/features/product/data/models/product_model.dart';

// Mock class for http.Client
class MockHttpClient extends Mock implements http.Client {}

void main() {
  late ProductRemoteDatasourceImpl datasource;
  late MockHttpClient mockHttpClient;

  const baseUrl = 'https://your-api-base-url.com/products';

  setUp(() {
    mockHttpClient = MockHttpClient();
    datasource = ProductRemoteDatasourceImpl(client: mockHttpClient);
  });

  final tProductModel = ProductModel(
    id: '1',
    name: 'Test Product',
    description: 'Test Description',
    imageUrl: 'https://example.com/image.png',
    price: 100.0,
  );

  final List<ProductModel> tProductModelList = [tProductModel];

  group('fetchProductsFromApi', () {
    test(
      'should return list of ProductModel when response code is 200',
      () async {
        // Arrange
        when(mockHttpClient.get(Uri.parse(baseUrl))).thenAnswer(
          (_) async => http.Response(
            json.encode(tProductModelList.map((e) => e.toJson()).toList()),
            200,
          ),
        );

        // Act
        final result = await datasource.fetchProductsFromApi();

        // Assert
        expect(result, isA<List<ProductModel>>());
        expect(result.length, 1);
        expect(result[0].id, tProductModel.id);
        verify(mockHttpClient.get(Uri.parse(baseUrl))).called(1);
        verifyNoMoreInteractions(mockHttpClient);
      },
    );

    test('should throw Exception when response code is not 200', () async {
      // Arrange
      when(
        mockHttpClient.get(Uri.parse(baseUrl)),
      ).thenAnswer((_) async => http.Response('Error', 404));

      // Act & Assert
      expect(() => datasource.fetchProductsFromApi(), throwsException);
      verify(mockHttpClient.get(Uri.parse(baseUrl))).called(1);
      verifyNoMoreInteractions(mockHttpClient);
    });
  });

  group('fetchProductById', () {
    final productUrl = '$baseUrl/1';

    test('should return a ProductModel when response code is 200', () async {
      // Arrange
      when(mockHttpClient.get(Uri.parse(productUrl))).thenAnswer(
        (_) async => http.Response(json.encode(tProductModel.toJson()), 200),
      );

      // Act
      final result = await datasource.fetchProductById('1');

      // Assert
      expect(result, isA<ProductModel>());
      expect(result?.id, '1');
      verify(mockHttpClient.get(Uri.parse(productUrl))).called(1);
      verifyNoMoreInteractions(mockHttpClient);
    });

    test('should return null when response code is 404', () async {
      // Arrange
      when(
        mockHttpClient.get(Uri.parse(productUrl)),
      ).thenAnswer((_) async => http.Response('Not Found', 404));

      // Act
      final result = await datasource.fetchProductById('1');

      // Assert
      expect(result, null);
      verify(mockHttpClient.get(Uri.parse(productUrl))).called(1);
      verifyNoMoreInteractions(mockHttpClient);
    });

    test(
      'should throw Exception when response code is other than 200 or 404',
      () async {
        // Arrange
        when(
          mockHttpClient.get(Uri.parse(productUrl)),
        ).thenAnswer((_) async => http.Response('Error', 500));

        // Act & Assert
        expect(() => datasource.fetchProductById('1'), throwsException);
        verify(mockHttpClient.get(Uri.parse(productUrl))).called(1);
        verifyNoMoreInteractions(mockHttpClient);
      },
    );
  });

  group('createProductOnApi', () {
    test('should complete successfully when response code is 201', () async {
      // Arrange
      when(
        mockHttpClient.post(
          Uri.parse(baseUrl),
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ),
      ).thenAnswer((_) async => http.Response('', 201));

      // Act
      final call = datasource.createProductOnApi(tProductModel);

      // Assert
      expect(call, completes);
      verify(
        mockHttpClient.post(
          Uri.parse(baseUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(tProductModel.toJson()),
        ),
      ).called(1);
      verifyNoMoreInteractions(mockHttpClient);
    });

    test('should throw Exception when response code is not 201', () async {
      // Arrange
      when(
        mockHttpClient.post(
          Uri.parse(baseUrl),
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ),
      ).thenAnswer((_) async => http.Response('Error', 400));

      // Act & Assert
      expect(
        () => datasource.createProductOnApi(tProductModel),
        throwsException,
      );
      verify(
        mockHttpClient.post(
          Uri.parse(baseUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(tProductModel.toJson()),
        ),
      ).called(1);
      verifyNoMoreInteractions(mockHttpClient);
    });
  });

  group('updateProductOnApi', () {
    final productUrl = '$baseUrl/1';

    test('should complete successfully when response code is 200', () async {
      // Arrange
      when(
        mockHttpClient.put(
          Uri.parse(productUrl),
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ),
      ).thenAnswer((_) async => http.Response('', 200));

      // Act
      final call = datasource.updateProductOnApi(tProductModel);

      // Assert
      expect(call, completes);
      verify(
        mockHttpClient.put(
          Uri.parse(productUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(tProductModel.toJson()),
        ),
      ).called(1);
      verifyNoMoreInteractions(mockHttpClient);
    });

    test('should throw Exception when response code is not 200', () async {
      // Arrange
      when(
        mockHttpClient.put(
          Uri.parse(productUrl),
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ),
      ).thenAnswer((_) async => http.Response('Error', 400));

      // Act & Assert
      expect(
        () => datasource.updateProductOnApi(tProductModel),
        throwsException,
      );
      verify(
        mockHttpClient.put(
          Uri.parse(productUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(tProductModel.toJson()),
        ),
      ).called(1);
      verifyNoMoreInteractions(mockHttpClient);
    });
  });

  group('deleteProductFromApi', () {
    final productUrl = '$baseUrl/1';

    test('should complete successfully when response code is 200', () async {
      // Arrange
      when(
        mockHttpClient.delete(Uri.parse(productUrl)),
      ).thenAnswer((_) async => http.Response('', 200));

      // Act
      final call = datasource.deleteProductFromApi('1');

      // Assert
      expect(call, completes);
      verify(mockHttpClient.delete(Uri.parse(productUrl))).called(1);
      verifyNoMoreInteractions(mockHttpClient);
    });

    test('should throw Exception when response code is not 200', () async {
      // Arrange
      when(
        mockHttpClient.delete(Uri.parse(productUrl)),
      ).thenAnswer((_) async => http.Response('Error', 400));

      // Act & Assert
      expect(() => datasource.deleteProductFromApi('1'), throwsException);
      verify(mockHttpClient.delete(Uri.parse(productUrl))).called(1);
      verifyNoMoreInteractions(mockHttpClient);
    });
  });
}
