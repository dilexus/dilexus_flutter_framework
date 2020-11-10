
import 'dart:async';

import 'package:flutter/services.dart';

class Dilexus {
  static const MethodChannel _channel =
      const MethodChannel('dilexus');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
