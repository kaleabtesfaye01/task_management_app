import 'package:flutter/material.dart';
import 'package:task_management_app/time_entry_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Management App',
      home: TimeEntryPage(),
    );
  }
}