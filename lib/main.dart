import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:task_management_app/firebase_options.dart';
import 'package:task_management_app/ui/query_result_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Management App',
      home: QueryResultPage(),
    );
  }
}
