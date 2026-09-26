import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pantribox_mobile/core/api/api_client.dart';
import 'package:pantribox_mobile/shared/models/api_version_info.dart';

final systemApiRepositoryProvider = Provider<SystemApiRepository>((ref) {
  return SystemApiRepository(ref.watch(dioProvider));
});

class SystemApiRepository {
  const SystemApiRepository(this._dio);

  final Dio _dio;

  Future<ApiVersionInfo> fetchVersion() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/system/version');
      return ApiVersionInfo.fromJson(response.data ?? <String, dynamic>{});
    } on DioException {
      return ApiVersionInfo.fallback();
    }
  }
}
