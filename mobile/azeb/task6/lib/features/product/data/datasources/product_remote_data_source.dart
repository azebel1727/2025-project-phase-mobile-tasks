import '../../../../domain/entities/product.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> fetchProductsFromApi();
  Future<ProductModel?> fetchProductById(String id);
  Future<void> createProductOnApi(ProductModel product);
  Future<void> updateProductOnApi(ProductModel product);
  Future<void> deleteProductFromApi(String id);
}
