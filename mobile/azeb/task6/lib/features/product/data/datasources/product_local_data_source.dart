// lib/features/product/data/datasources/product_local_data_source.dart

import '../../domain/entities/product.dart';

abstract class ProductLocalDataSource {
  Future<List<Product>> getCachedProducts();
  Future<void> cacheProducts(List<Product> products);

  Future<Product?> getProduct(String id);
  Future<void> createProduct(Product product);
  Future<void> updateProduct(Product product);
  Future<void> deleteProduct(String id);
}
