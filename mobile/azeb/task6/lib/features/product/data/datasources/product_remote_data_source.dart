// lib/features/product/data/datasources/product_remote_data_source.dart

import '../../domain/entities/product.dart';

abstract class ProductRemoteDataSource {
  Future<List<Product>> fetchProductsFromApi();
  Future<Product?> fetchProductById(String id);
  Future<void> createProductOnApi(Product product);
  Future<void> updateProductOnApi(Product product);
  Future<void> deleteProductFromApi(String id);
}
