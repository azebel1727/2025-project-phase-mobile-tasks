import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/product_model.dart';
import 'product_local_data_source.dart';

const cachedProductsKey = 'CACHED_PRODUCTS';

class ProductLocalDatasourceImpl implements ProductLocalDataSource {
  final SharedPreferences sharedPreferences;

  ProductLocalDatasourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    final jsonString = json.encode(products.map((p) => p.toJson()).toList());
    await sharedPreferences.setString(cachedProductsKey, jsonString);
  }

  @override
  Future<List<ProductModel>> getLastCachedProducts() async {
    final jsonString = sharedPreferences.getString(cachedProductsKey);
    if (jsonString != null) {
      final List<dynamic> decodedJson = json.decode(jsonString);
      return decodedJson
          .map<ProductModel>((json) => ProductModel.fromJson(json))
          .toList();
    } else {
      throw Exception('No Cached Products');
    }
  }

  @override
  Future<ProductModel?> getProductById(String id) async {
    final products = await getLastCachedProducts();
    try {
      return products.firstWhere((product) => product.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> createProduct(ProductModel product) async {
    final products = await getLastCachedProducts();
    final updatedProducts = List<ProductModel>.from(products)..add(product);
    await cacheProducts(updatedProducts);
  }

  @override
  Future<void> updateProduct(ProductModel product) async {
    final products = await getLastCachedProducts();
    final updatedProducts = products
        .map((p) => p.id == product.id ? product : p)
        .toList();
    await cacheProducts(updatedProducts);
  }

  @override
  Future<void> deleteProduct(String id) async {
    final products = await getLastCachedProducts();
    final updatedProducts = products.where((p) => p.id != id).toList();
    await cacheProducts(updatedProducts);
  }
}
