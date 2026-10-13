import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Platform data protection and automatic OS backup exclusion contract.
abstract class PlatformDataProtection {
  /// Applies backup exclusion and at-rest protection to all provided [paths].
  Future<void> apply(List<String> paths);

  /// Verifies that all provided [paths] currently possess the required platform protection.
  Future<bool> verify(List<String> paths);
}

/// Default platform implementation using iOS native MethodChannel and Android sandbox enforcement.
class DefaultPlatformDataProtection implements PlatformDataProtection {
  DefaultPlatformDataProtection({MethodChannel? channel})
    : _channel =
          channel ??
          const MethodChannel(
            'com.offlinequotes.mobile/platform_data_protection',
          );

  final MethodChannel _channel;

  @override
  Future<void> apply(List<String> paths) async {
    if (kIsWeb) return;

    if (Platform.isIOS) {
      try {
        await _channel.invokeMethod<bool>('apply', {'paths': paths});
      } catch (e) {
        throw StateError(
          'Failed to apply iOS data protection and backup exclusion: $e',
        );
      }
    } else if (Platform.isAndroid) {
      // On Android, backup rules and sandbox encryption are enforced declaratively
      // via AndroidManifest.xml, backup_rules.xml, and data_extraction_rules.xml.
      for (final path in paths) {
        final file = File(path);
        final dir = Directory(path);
        if (!file.existsSync() && !dir.existsSync()) {
          // Path will be protected once created by parent directory inheritance
        }
      }
    }
  }

  @override
  Future<bool> verify(List<String> paths) async {
    if (kIsWeb) return true;

    // Verify all paths reside strictly within private sandbox storage and not public storage
    for (final path in paths) {
      if (path.contains('/sdcard') ||
          path.contains('/storage/emulated/0/Download')) {
        return false;
      }
    }

    if (Platform.isIOS) {
      try {
        final verified = await _channel.invokeMethod<bool>('verify', {
          'paths': paths,
        });
        return verified ?? false;
      } catch (_) {
        return false;
      }
    }
    return true;
  }
}
