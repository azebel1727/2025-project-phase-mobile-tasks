import 'package:task6/domain/entities/product.dart';

abstract class ProductLocalDataSource {
  Future<void> cacheProducts(List<Product> products);
  Future<List<Product>> getCachedProducts();

  Future<void> addProductToCache(Product product);
  Future<void> updateCachedProduct(Product product);
  Future<void> removeProductFromCache(String id);
  Future<Product?> getCachedProductById(String id);
}
