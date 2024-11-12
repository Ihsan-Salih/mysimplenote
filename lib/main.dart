import 'package:flutter/material.dart';
import 'views/home_screen.dart';

void main() {
  runApp(const MySimpleNoteApp());
}

class MySimpleNoteApp extends StatelessWidget {
  const MySimpleNoteApp({super.key}); 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MySimpleNote',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(), 
    );
  }
}
