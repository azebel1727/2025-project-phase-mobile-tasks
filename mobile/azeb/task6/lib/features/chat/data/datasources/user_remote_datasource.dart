// user_remote_datasource.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/user.dart';
import '/features/auth/data/datasources/auth_local_data_source.dart';

class UserRemoteDatasource {
  final http.Client client;
  final AuthLocalDataSource authLocalDataSource;

  UserRemoteDatasource({
    required this.client,
    required this.authLocalDataSource,
  });

  Future<String> _getToken() async {
    final token = await authLocalDataSource.getToken();
    print('[UserRemoteDatasource] Retrieved token: $token');
    if (token == null || token.isEmpty) {
      print('[UserRemoteDatasource] No valid token found');
      throw Exception('No valid token found');
    }
    return token;
  }

  Future<User> getMyProfile() async {
    final token = await _getToken();
    print('[UserRemoteDatasource] Fetching profile with token: $token');
    final response = await client.get(
      Uri.parse(
        'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v3/users/me',
      ),
      headers: {'Authorization': 'Bearer $token'},
    );
    print(
      '[UserRemoteDatasource] Profile response status: ${response.statusCode}',
    );
    print('[UserRemoteDatasource] Profile response body: ${response.body}');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("[UserRemoteDatasource] Profile loaded successfully: $data");
      final userdata =
          data['data'] ?? data; // Handle 'data' key or direct object
      final user = User(
        id: userdata['id'] ?? userdata['_id'],
        name: userdata['name'],
        email: userdata['email'],
      );
      print("[UserRemoteDatasource] User object created: $user");
      return user;
    }
    print("[UserRemoteDatasource] Failed to load profile");
    throw Exception('Failed to load profile');
  }

  Future<List<User>> getUsers() async {
    print("[UserRemoteDatasource] Loading users...");
    final token = await _getToken();
    print('[UserRemoteDatasource] Fetching users with token: $token');
    final response = await client.get(
      Uri.parse(
        'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v3/users',
      ),
      headers: {'Authorization': 'Bearer $token'},
    );
    print(
      '[UserRemoteDatasource] Users response status: ${response.statusCode}',
    );
    print('[UserRemoteDatasource] Users response body: ${response.body}');
    if (response.statusCode == 200) {
      print("[UserRemoteDatasource] Users loaded successfully");
      final jsonbody = json.decode(response.body) as Map<String, dynamic>;
      print(jsonbody);
      final list = jsonbody['data'] as List<dynamic>? ?? [];
      final users = list
          .map(
            (u) => User(
              id: u['id']?? u['_id'],
              name: u['name'],
              email: u['email'],
              //profileImageUrl: u['profileImageUrl'],
            ),
          )
          .toList();
      print("[UserRemoteDatasource] User list created: $users");
      return users;
    }
    print("[UserRemoteDatasource] Failed to load users");
    throw Exception('Failed to load users');
  }
}
