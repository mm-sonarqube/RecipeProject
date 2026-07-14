import 'package:dio/dio.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  /// Calls POST https://dummyjson.com/auth/login
  /// Throws [Exception] on 4xx/5xx or network errors.
  Future<UserModel> login(String username, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  static const String _baseUrl = 'https://dummyjson.com';

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<UserModel> login(String username, String password) async {
    try {
      final response = await dio.post(
        '$_baseUrl/auth/login',
        data: {
          'username': username,
          'password': password,
          'expiresInMins': 30,
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      return UserModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final message = e.response?.data?['message'] as String? ??
          e.message ??
          'Unknown error';
      throw Exception('Login failed ($statusCode): $message');
    }
  }
}
