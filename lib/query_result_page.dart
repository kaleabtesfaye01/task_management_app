import 'package:flutter/material.dart';
import 'package:task_management_app/query_input_page.dart';
import 'package:task_management_app/entry_input_page.dart';
import 'package:task_management_app/time_entry_card.dart';

class QueryResultPage extends StatefulWidget {
  const QueryResultPage({super.key});

  @override
  State<QueryResultPage> createState() => _QueryResultPageState();
}

class _QueryResultPageState extends State<QueryResultPage> {
  // variables
  String? _query = 'tag';
  String? _value = 'JAVA';

  // modules

  // ui
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Query Result Page'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const QueryInputPage()),
              );
              if (result != null) {
                setState(() {
                  _query = result['query'];
                  _value = result['value'];
                });
              }
            },
          ),
        ],
      ),
      body: const SafeArea(
        child: TimeEntryCard()
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EntryInputPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}