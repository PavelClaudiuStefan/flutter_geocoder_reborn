import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_geocoder_reborn/flutter_geocoder_reborn.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_geocoder_reborn');

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
    expect(await FlutterGeocoderReborn.platformVersion, '42');
  });
}
