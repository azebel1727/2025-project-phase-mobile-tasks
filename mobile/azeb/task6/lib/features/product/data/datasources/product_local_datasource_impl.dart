import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task6/domain/entities/product.dart';
import 'product_local_data_source.dart';

const cachedProductsKey = 'CACHED_PRODUCTS';

class ProductLocalDatasourceImpl implements ProductLocalDataSource {
  final SharedPreferences sharedPreferences;

  ProductLocalDatasourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheProducts(List<Product> products) async {
    final jsonList = products
        .map(
          (p) => {
            'id': p.id,
            'name': p.name,
            'description': p.description,
            'price': p.price,
            'imageUrl': p.imageUrl,
          },
        )
        .toList();
    final jsonString = json.encode(jsonList);
    await sharedPreferences.setString(cachedProductsKey, jsonString);
  }

  @override
  Future<List<Product>> getCachedProducts() async {
    final jsonString = sharedPreferences.getString(cachedProductsKey);
    if (jsonString == null) throw Exception('No cached products found');

    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList
        .map(
          (json) => Product(
            id: json['id'],
            name: json['name'],
            description: json['description'],
            price: json['price'],
            imageUrl: json['imageUrl'],
          ),
        )
        .toList();
  }

  @override
  Future<void> addProductToCache(Product product) async {
    try {
      final products = await getCachedProducts();
      products.add(product);
      await cacheProducts(products);
    } catch (_) {
      await cacheProducts([product]);
    }
  }

  @override
  Future<void> updateCachedProduct(Product product) async {
    final products = await getCachedProducts();
    final index = products.indexWhere((p) => p.id == product.id);
    if (index < 0) throw Exception('Product not found in cache');
    products[index] = product;
    await cacheProducts(products);
  }

  @override
  Future<void> removeProductFromCache(String id) async {
    final products = await getCachedProducts();
    products.removeWhere((p) => p.id == id);
    await cacheProducts(products);
  }

  @override
  Future<Product?> getCachedProductById(String id) async {
    final products = await getCachedProducts();
    try {
      return products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}
