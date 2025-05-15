import 'package:flutter/material.dart';
import 'package:window_size/window_size.dart';
import 'dart:io';

import 'camera_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // 데스크탑 환경에서만 창 크기 설정
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('Mobile Detector');
    setWindowMinSize(const Size(600, 1000));
    setWindowMaxSize(const Size(600, 1000));
    setWindowFrame(const Rect.fromLTWH(100, 100, 540, 960));
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aeye',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const CameraPage(),
    );
  }
}
