import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appLoggerProvider = Provider<AppLogger>((ref) => const AppLogger());

class AppLogger {
  const AppLogger();

  void warning(String message, {Object? error}) {
    debugPrint('[PantriBox][warn] $message ${error ?? ''}');
  }
}
