import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insta_share/insta_share.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> writeToFile(ByteData data, String path) async {
    var buffer = data.buffer;
    await File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Plugin example app'),
        ),
        body: Column(
          children: [
            TextButton(
              onPressed: () async {
                String filename = 'test.jpeg';
                String dir = (await getTemporaryDirectory()).path;
                ByteData bytes = await rootBundle.load('assets/$filename');
                File file = File('$dir/$filename');
                if (await file.exists()) {
                  await writeToFile(bytes, file.path);
                }
                InstaShare.shareToFeed(
                    path: file.path, type: SharedFileType.image);
              },
              child: Text('Share image'),
            ),
            TextButton(
              onPressed: () async {
                String filename = 'test.mp4';
                String dir = (await getTemporaryDirectory()).path;
                ByteData bytes = await rootBundle.load('assets/$filename');
                File file = File('$dir/$filename');
                if (await file.exists()) {
                  await writeToFile(bytes, file.path);
                }
                InstaShare.shareToFeed(
                    path: file.path, type: SharedFileType.image);
              },
              child: Text('Share video'),
            ),
          ],
        ),
      ),
    );
  }
}
