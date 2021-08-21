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
        body: Center(
          child: Column(
            children: [
              TextButton(
                onPressed: () async {
                  String filename = 'test.jpeg';
                  String dir = (await getTemporaryDirectory()).path;
                  ByteData bytes = await rootBundle.load('assets/$filename');
                  File file = File('$dir/$filename');
                  await writeToFile(bytes, file.path);
                  InstaShare.share(path: file.path, type: FileType.image);
                },
                child: Text('Share image'),
              ),
              TextButton(
                onPressed: () async {
                  String filename = 'test.mp4';
                  String dir = (await getTemporaryDirectory()).path;
                  ByteData bytes = await rootBundle.load('assets/$filename');
                  File file = File('$dir/$filename');
                  await writeToFile(bytes, file.path);
                  InstaShare.share(path: file.path, type: FileType.video);
                },
                child: Text('Share video'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
