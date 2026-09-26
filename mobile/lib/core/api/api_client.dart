import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pantribox_mobile/app/configuration/app_environment.dart';
import 'package:pantribox_mobile/core/logging/app_logger.dart';

final appEnvironmentProvider = Provider<AppEnvironment>((ref) {
  return AppEnvironment.current();
});

final dioProvider = Provider<Dio>((ref) {
  final environment = ref.watch(appEnvironmentProvider);
  final logger = ref.watch(appLoggerProvider);

  final dio = Dio(
    BaseOptions(
      baseUrl: environment.apiBaseUrl,
      connectTimeout: const Duration(seconds: 2),
      receiveTimeout: const Duration(seconds: 2),
      headers: const {'X-PantriBox-Client': 'mobile-bootstrap'},
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onError: (error, handler) {
        logger.warning('API request failed', error: error);
        handler.next(error);
      },
    ),
  );

  return dio;
});
