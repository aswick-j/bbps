import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'bbps_platform_interface.dart';

/// An implementation of [BbpsPlatform] that uses method channels.
class MethodChannelBbps extends BbpsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('bbps');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
