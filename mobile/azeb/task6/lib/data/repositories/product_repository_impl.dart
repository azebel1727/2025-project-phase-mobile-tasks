import 'package:task6/core/error/network/network_info.dart';
import 'package:task6/domain/entities/product.dart';
import 'package:task6/domain/repositories/product_repository.dart';
import '../../features/product/data/datasources/product_local_data_source.dart';
import '../../features/product/data/datasources/product_remote_data_source.dart';
import '../../features/product/data/models/product_model.dart';

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
        final remoteModels = await remoteDataSource.fetchProductsFromApi();
        final remoteProducts = remoteModels.map((model) => model.toEntity()).toList();
        await localDataSource.cacheProducts(remoteProducts);
        return remoteProducts;
      } catch (e) {
        // If remote fetch fails, fallback to local cache
        return localDataSource.getCachedProducts();
      }
    } else {
      return localDataSource.getCachedProducts();
    }
  }

  @override
  Future<Product?> getProductById(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final model = await remoteDataSource.fetchProductById(id);
        return model?.toEntity();
      } catch (e) {
        // Fallback to cache if remote fetch fails
        return localDataSource.getCachedProductById(id);
      }
    } else {
      return localDataSource.getCachedProductById(id);
    }
  }

  @override
  Future<void> createProduct(Product product) async {
    final model = ProductModel.fromEntity(product);
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.createProductOnApi(model);
        await localDataSource.addProductToCache(product);
      } catch (e) {
        rethrow;
      }
    } else {
      throw Exception('No internet connection');
    }
  }

  @override
  Future<void> updateProduct(Product product) async {
    final model = ProductModel.fromEntity(product);
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.updateProductOnApi(model);
        await localDataSource.updateCachedProduct(product);
      } catch (e) {
        rethrow;
      }
    } else {
      throw Exception('No internet connection');
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteProductFromApi(id);
        await localDataSource.removeProductFromCache(id);
      } catch (e) {
        rethrow;
      }
    } else {
      throw Exception('No internet connection');
    }
  }
}
