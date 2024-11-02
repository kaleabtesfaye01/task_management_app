import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:task_management_app/firebase_options.dart';
import 'package:task_management_app/query_input_page.dart';

Future<void> main() async{
  runApp(const MyApp());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Management App',
      home: QueryInputPage(),
    );
  }
}