import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pantribox_mobile/core/api/api_client.dart';

final authenticationRepositoryProvider = Provider<AuthenticationRepository>((
  ref,
) {
  return AuthenticationRepository(ref.watch(dioProvider));
});

class AuthenticationRepository {
  const AuthenticationRepository(this._dio);

  final Dio _dio;

  Future<String> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/login',
      data: {'email': email, 'password': password},
    );
    final token = response.data?['access_token'] as String?;
    if (token == null || token.isEmpty) {
      throw const AuthenticationException(
        'The sign-in response was incomplete.',
      );
    }
    return token;
  }
}

class AuthenticationException implements Exception {
  const AuthenticationException(this.message);

  final String message;
}
