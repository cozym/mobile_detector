import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  WebSocketChannel? channel;
  Uint8List? frameBytes;
  String objectName = "person";

  void startStreaming() {
    final uri = Uri.parse("ws://localhost:8000/ws/$objectName");
    channel = WebSocketChannel.connect(uri);

    channel!.stream.listen((event) {
      setState(() {
        frameBytes = base64Decode(event);
      });
    });
  }

  @override
  void dispose() {
    channel?.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Mobile Detector"),
        centerTitle: true,
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Center(
        child: Container(
          width: 400, // 모바일 화면 크기
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.tealAccent,
                decoration: InputDecoration(
                  labelText: "탐지할 객체 (예: cup, person)",
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.grey[850],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (val) => objectName = val,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent[700],
                  minimumSize: const Size.fromHeight(45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: startStreaming,
                child: const Text("스트리밍 시작", style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: frameBytes != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.memory(frameBytes!, gaplessPlayback: true),
                        )
                      : const Center(
                          child: Text(
                            "영상 없음",
                            style: TextStyle(color: Colors.white54),
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey[900],
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            Icon(Icons.home, color: Colors.white38),
            Icon(Icons.camera_alt, color: Colors.white38),
            Icon(Icons.settings, color: Colors.white38),
          ],
        ),
      ),
    );
  }
}
