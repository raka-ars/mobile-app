import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Web via Jenkins',
      home: Scaffold(
        appBar: AppBar(title: const Text(' Jenkins + Docker + Ngrok')),
        body: const Center(
          child: Text(
            'Build Success! Flutter Web running via Docker!',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
