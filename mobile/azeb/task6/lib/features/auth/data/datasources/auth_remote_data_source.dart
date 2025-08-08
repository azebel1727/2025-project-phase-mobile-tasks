import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class AuthRemoteDataSource {
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  });

  Future<String> login({required String email, required String password});

  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;
  final String baseUrl =
      'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v2/auth';

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    print('Signing up with name: $name, email: $email');

    final response = await client.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      print('Sign up successful');
      print(response.body);
    } else {
      print('Sign up failed with status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to sign up');
    }
  }

  @override
  Future<String> login({
    required String email,
    required String password,
  }) async {
    print('Signing In with password: $password, email: $email');

    final response = await client.post(
      Uri.parse('$baseUrl/login'),
      body: jsonEncode({'email': email, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Sign In successful');
      final body = (jsonDecode(response.body))['data'];
      print(body['access_token']);
      return body['access_token']; // Adjust if token key is different
    } else {
      print('Sign in failed with status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to sign In');
    }
  }

  @override
  Future<void> logout() async {
    // Implement if your API supports logout
  }
}
