import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('정보'),
      ),
      body: const Center(
        child: Text(
          '정보 화면',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
