import 'package:task6/core/error/network/network_info.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_data_source.dart';
import '../datasources/product_remote_data_source.dart';
import '../models/product_model.dart';

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
        // Convert entities to models before caching
        final productModels = remoteProducts
            .map(ProductModel.fromEntity)
            .toList();
        await localDataSource.cacheProducts(productModels);
        return remoteProducts;
      } catch (e) {
        final cachedModels = await localDataSource.getLastCachedProducts();
        return cachedModels.map((model) => model.toEntity()).toList();
      }
    } else {
      final cachedModels = await localDataSource.getLastCachedProducts();
      return cachedModels.map((model) => model.toEntity()).toList();
    }
  }

  @override
  Future<Product?> getProductById(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteProduct = await remoteDataSource.fetchProductById(id);
        return remoteProduct;
      } catch (e) {
        final cachedModel = await localDataSource.getProductById(id);
        return cachedModel?.toEntity();
      }
    } else {
      final cachedModel = await localDataSource.getProductById(id);
      return cachedModel?.toEntity();
    }
  }

  @override
  Future<void> createProduct(Product product) async {
    if (await networkInfo.isConnected) {
      await remoteDataSource.createProductOnApi(product);
      await localDataSource.createProduct(ProductModel.fromEntity(product));
    } else {
      throw NoInternetException();
    }
  }

  @override
  Future<void> updateProduct(Product product) async {
    if (await networkInfo.isConnected) {
      await remoteDataSource.updateProductOnApi(product);
      await localDataSource.updateProduct(ProductModel.fromEntity(product));
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
