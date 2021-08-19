import 'dart:async';

import 'package:flutter/services.dart';

/// Instagram shared file type
enum SharedFileType { image, video }

extension SharedFileTypeEx on SharedFileType {
  String get value {
    return this.toString().split('.').last;
  }
}

class InstaShare {
  static const MethodChannel _channel =
      const MethodChannel('com.kurenai7968.insta_share.method');

  static Future<void> shareToFeed(
      {required String path, required SharedFileType type}) async {
    Map<String, dynamic> params = {"path": path, "type": type.value};
    _channel.invokeMethod('shareToFeed', params);
  }
}
