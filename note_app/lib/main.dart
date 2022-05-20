import 'package:flutter/material.dart';

import 'note_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Note_Page(),
      routes: {
        Note_Page.id: (context) => Note_Page(),
      },
    );
  }
}
