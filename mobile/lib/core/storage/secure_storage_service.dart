import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final secureStorageProvider = Provider<SecureStorageService>((ref) {
  return const SecureStorageService(FlutterSecureStorage());
});

class SecureStorageService {
  const SecureStorageService(this._storage);

  final FlutterSecureStorage _storage;

  Future<void> writeToken(String token) {
    return _storage.write(key: 'auth_token', value: token);
  }

  Future<String?> readToken() {
    return _storage.read(key: 'auth_token');
  }
}
