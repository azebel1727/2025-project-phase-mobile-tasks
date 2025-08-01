import 'package:task6/core/error/network/network_info.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_data_source.dart';
import '../datasources/product_remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<List<Product>> getAllProducts() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteProducts = await remoteDataSource.fetchProductsFromApi();
        await localDataSource.cacheProducts(remoteProducts);
        return remoteProducts;
      } catch (e) {
        return await localDataSource.getCachedProducts();
      }
    } else {
      return await localDataSource.getCachedProducts();
    }
  }

  @override
  Future<Product?> getProductById(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteProduct = await remoteDataSource.fetchProductById(id);
        return remoteProduct;
      } catch (e) {
        return await localDataSource.getProduct(id);
      }
    } else {
      return await localDataSource.getProduct(id);
    }
  }

  @override
  Future<void> createProduct(Product product) async {
    if (await networkInfo.isConnected) {
      await remoteDataSource.createProductOnApi(product);
      await localDataSource.createProduct(product);
    } else {
      throw NoInternetException();
    }
  }

  @override
  Future<void> updateProduct(Product product) async {
    if (await networkInfo.isConnected) {
      await remoteDataSource.updateProductOnApi(product);
      await localDataSource.updateProduct(product);
    } else {
      throw Exception("No network connection. Cannot update product.");
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    if (await networkInfo.isConnected) {
      await remoteDataSource.deleteProductFromApi(id);
      await localDataSource.deleteProduct(id);
    } else {
      throw Exception("No network connection. Cannot delete product.");
    }
  }
}
