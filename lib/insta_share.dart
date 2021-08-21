import 'dart:async';

import 'package:flutter/services.dart';

/// Instagram shared file type
enum FileType { image, video }

extension FileTypeEx on FileType {
  /// FileType to string.
  String get value {
    return this.toString().split('.').last;
  }
}

class InstaShare {
  /// InstaShare method channel
  static const MethodChannel _channel =
      const MethodChannel('com.kurenai7968.insta_share.method');

  /// Share image or video to instagram
  static Future<void> share(
      {required String path, required FileType type}) async {
    Map<String, dynamic> params = {"path": path, "type": type.value};
    _channel.invokeMethod<bool>('share', params);
  }

  /// Check instagram whether installed on the device
  static Future<bool> get installed async {
    bool shared =
        await _channel.invokeMethod<bool>('installed').then((value) => value!);

    return shared;
  }
}
