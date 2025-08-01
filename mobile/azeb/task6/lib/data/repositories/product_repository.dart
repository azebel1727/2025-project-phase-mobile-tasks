import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final List<Product> _products = [];

  @override
  List<Product> getAllProducts() => _products;

  @override
  Product? getProductById(String id) =>
      _products.firstWhere((product) => product.id == id, orElse: () => null);

  @override
  void createProduct(Product product) {
    _products.add(product);
  }

  @override
  void updateProduct(Product product) {
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) _products[index] = product;
  }

  @override
  void deleteProduct(String id) {
    _products.removeWhere((product) => product.id == id);
  }
}
