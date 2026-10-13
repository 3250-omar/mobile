import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../core/diagnostics/app_logger.dart';
import '../../core/errors/failure_mapper.dart';
import 'app_environment.dart';

/// Sets up root zone error boundaries and launches the application.
Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  final logger = AppLogger();

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    logger.error(
      'FLUTTER_ERROR',
      attributes: {
        'library': details.library ?? 'unknown',
        'context': details.context?.toDescription() ?? 'unknown',
        'error': FailureMapper.map(details.exception).code,
      },
    );
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    logger.error(
      'PLATFORM_DISPATCHER_ERROR',
      attributes: {'error': FailureMapper.map(error, stackTrace: stack).code},
    );
    return true;
  };

  WidgetsFlutterBinding.ensureInitialized();

  // Validate environment upfront
  AppEnvironment.fromEnvironment();

  final rootWidget = await builder();
  runApp(rootWidget);
}
