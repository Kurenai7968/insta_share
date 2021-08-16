
import 'dart:async';

import 'package:flutter/services.dart';

class InstaShare {
  static const MethodChannel _channel =
      const MethodChannel('insta_share');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
