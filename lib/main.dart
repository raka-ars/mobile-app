import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Web Demo',
      home: Scaffold(
        appBar: AppBar(title: const Text('Hello Flutter Web 🚀')),
        body: const Center(
          child: Text(
            'Deployed with Jenkins + Docker + Ngrok!',
            style: TextStyle(fontSize: 22),
          ),
        ),
      ),
    );
  }
}
