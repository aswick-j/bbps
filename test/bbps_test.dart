import 'package:flutter_test/flutter_test.dart';
import 'package:bbps/bbps.dart';
import 'package:bbps/bbps_platform_interface.dart';
import 'package:bbps/bbps_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockBbpsPlatform with MockPlatformInterfaceMixin implements BbpsPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final BbpsPlatform initialPlatform = BbpsPlatform.instance;

  test('$MethodChannelBbps is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelBbps>());
  });
}
