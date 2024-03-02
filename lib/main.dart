import 'package:boksl_subway/widgets/MyDropdownWithTexts.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '복슬지하철(실시간 도착 안내)',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('수도권 지하철 실시간 도착 안내'),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: MyDropdownWithTexts(),
      ),
    );
  }
}
