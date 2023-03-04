import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:watermark/View/home.dart';
import 'package:watermark/Controller/merge_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ImageAudioApp());
}

class ImageAudioApp extends StatefulWidget {
  @override
  _ImageAudioAppState createState() => _ImageAudioAppState();
}

class _ImageAudioAppState extends State<ImageAudioApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(home: HomePage());
  }
}
