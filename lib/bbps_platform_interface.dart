import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'bbps_method_channel.dart';

abstract class BbpsPlatform extends PlatformInterface {
  /// Constructs a BbpsPlatform.
  BbpsPlatform() : super(token: _token);

  static final Object _token = Object();

  static BbpsPlatform _instance = MethodChannelBbps();

  /// The default instance of [BbpsPlatform] to use.
  ///
  /// Defaults to [MethodChannelBbps].
  static BbpsPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BbpsPlatform] when
  /// they register themselves.
  static set instance(BbpsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
