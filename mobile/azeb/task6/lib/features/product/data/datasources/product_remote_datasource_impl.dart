import 'dart:convert';

import 'package:http/http.dart' as http;
import '../../../../domain/entities/product.dart';
import '../models/product_model.dart';
import 'product_remote_data_source.dart';

const String baseUrl = 'https://your-api-base-url.com/products';

class ProductRemoteDatasourceImpl implements ProductRemoteDataSource {
  final http.Client client;

  ProductRemoteDatasourceImpl({required this.client});

  @override
  Future<List<Product>> fetchProductsFromApi() async {
    final response = await client.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      final products = jsonList
          .map((json) => ProductModel.fromJson(json).toEntity())
          .toList();
      return products;
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Future<Product?> fetchProductById(String id) async {
    final response = await client.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return ProductModel.fromJson(json.decode(response.body)).toEntity();
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Failed to load product');
    }
  }

  @override
  Future<void> createProductOnApi(Product product) async {
    final productModel = ProductModel.fromEntity(product);
    final response = await client.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(productModel.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create product');
    }
  }

  @override
  Future<void> updateProductOnApi(Product product) async {
    final productModel = ProductModel.fromEntity(product);
    final response = await client.put(
      Uri.parse('$baseUrl/${product.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(productModel.toJson()),
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
