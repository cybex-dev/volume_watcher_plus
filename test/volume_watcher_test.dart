import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volume_watcher_plus/volume_watcher_plus.dart';

void main() {
  const MethodChannel channel = MethodChannel('volume_watcher_plus');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await VolumeWatcherPlus.platformVersion, '42');
  });
}
