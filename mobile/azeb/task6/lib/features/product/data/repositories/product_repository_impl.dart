// lib/features/product/data/repositories/product_repository_impl.dart

import '../../../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_data_source.dart';
import '../datasources/product_remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<Product>> getAllProducts() async {
    try {
      final remoteProducts = await remoteDataSource.fetchProductsFromApi();
      await localDataSource.cacheProducts(remoteProducts);
      return remoteProducts;
    } catch (e) {
      // On failure, fallback to local cache
      return await localDataSource.getCachedProducts();
    }
  }

  @override
  Future<Product?> getProductById(String id) async {
    try {
      final remoteProduct = await remoteDataSource.fetchProductById(id);
      return remoteProduct;
    } catch (e) {
      return await localDataSource.getProduct(id);
    }
  }

  @override
  Future<void> createProduct(Product product) async {
    await remoteDataSource.createProductOnApi(product);
    await localDataSource.createProduct(product);
  }

  @override
  Future<void> updateProduct(Product product) async {
    await remoteDataSource.updateProductOnApi(product);
    await localDataSource.updateProduct(product);
  }

  @override
  Future<void> deleteProduct(String id) async {
    await remoteDataSource.deleteProductFromApi(id);
    await localDataSource.deleteProduct(id);
  }
}
