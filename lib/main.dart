import 'package:flutter/material.dart';
import 'home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blue Terminal',
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: Home()
    );
  }
}