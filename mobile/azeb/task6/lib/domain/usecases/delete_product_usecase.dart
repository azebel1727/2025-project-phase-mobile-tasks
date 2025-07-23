import '../repositories/product_repository.dart';

class DeleteProductUsecase {
  final ProductRepository repository;

  DeleteProductUsecase(this.repository);

  void call(String id) {
    repository.deleteProduct(id);
  }
}
