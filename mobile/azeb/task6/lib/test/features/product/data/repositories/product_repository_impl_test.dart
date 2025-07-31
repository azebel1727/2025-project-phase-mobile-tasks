import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:task6/features/product/data/models/product_model.dart';
import 'package:task6/features/product/data/repositories/product_repository_impl.dart';
import 'package:task6/core/error/network/network_info.dart';
import 'package:task6/features/product/data/datasources/product_remote_data_source.dart';
import 'package:task6/features/product/data/datasources/product_local_data_source.dart';
import 'package:task6/domain/entities/product.dart';


class MockRemoteDataSource extends Mock implements ProductRemoteDataSource {}
class MockLocalDataSource extends Mock implements ProductLocalDataSource {}
class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late ProductRepositoryImpl repository;
  late MockRemoteDataSource mockRemote;
  late MockLocalDataSource mockLocal;
  late MockNetworkInfo mockNetwork;

  setUp(() {
    mockRemote = MockRemoteDataSource();
    mockLocal = MockLocalDataSource();
    mockNetwork = MockNetworkInfo();
    repository = ProductRepositoryImpl(
      remoteDataSource: mockRemote,
      localDataSource: mockLocal,
      networkInfo: mockNetwork,
    );
  });

  final productModels = [
    ProductModel(
      id: '1',
      name: 'Test Product',
      description: 'Test Desc',
      imageUrl: 'http://img.com/img.png',
      price: 99.99,
    ),
  ];
  final products = productModels.map((e) => e.toEntity()).toList();

  test('Should return remote data when network is available', () async {
    when(mockNetwork.isConnected).thenAnswer((_) async => true);
    when(mockRemote.fetchProducts()).thenAnswer((_) async => productModels);
    when(mockLocal.cacheProducts(any)).thenAnswer((_) async => null);

    final result = await repository.getAllProducts();

    expect(result, Right(products));
    verify(mockRemote.fetchProducts());
    verify(mockLocal.cacheProducts(productModels));
  });

  test('Should return local data when network is unavailable', () async {
    when(mockNetwork.isConnected).thenAnswer((_) async => false);
    when(mockLocal.getCachedProducts()).thenAnswer((_) async => productModels);

    final result = await repository.getAllProducts();

    expect(result, Right(products));
    verify(mockLocal.getCachedProducts());
  });
}
