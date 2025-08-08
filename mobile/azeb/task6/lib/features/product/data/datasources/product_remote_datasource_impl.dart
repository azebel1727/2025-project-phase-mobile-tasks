import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:task6/features/product/data/models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> fetchProductsFromApi();
  Future<ProductModel?> fetchProductById(String id);
  Future<void> createProductOnApi(ProductModel product);
  Future<void> updateProductOnApi(ProductModel product);
  Future<void> deleteProductFromApi(String id);
}

class ProductRemoteDatasourceImpl implements ProductRemoteDataSource {
  final http.Client client;
  static const String baseUrl = 'https://your-api-base-url.com/products';

  ProductRemoteDatasourceImpl({required this.client});

  @override
  Future<List<ProductModel>> fetchProductsFromApi() async {
    final response = await client.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Future<ProductModel?> fetchProductById(String id) async {
    final response = await client.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      final jsonMap = json.decode(response.body);
      return ProductModel.fromJson(jsonMap);
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Failed to load product');
    }
  }

  @override
  Future<void> createProductOnApi(ProductModel product) async {
    final response = await client.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create product');
    }
  }

  @override
  Future<void> updateProductOnApi(ProductModel product) async {
    final response = await client.put(
      Uri.parse('$baseUrl/${product.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update product');
    }
  }

  @override
  Future<void> deleteProductFromApi(String id) async {
    final response = await client.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete product');
    }
  }
}
