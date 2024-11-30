import 'package:flutter/material.dart';
import 'package:task_management_app/data/repository.dart';
import 'package:task_management_app/query_input_page.dart';
import 'package:task_management_app/entry_input_page.dart';
import 'package:task_management_app/model/time_entry.dart';
import 'package:task_management_app/time_entry_card.dart';

class QueryResultPage extends StatefulWidget {
  const QueryResultPage({super.key});

  @override
  State<QueryResultPage> createState() => _QueryResultPageState();
}

class _QueryResultPageState extends State<QueryResultPage> {
  // variables
  final _repository = Repository();
  String? _query;
  String? _value;
  List<TimeEntry>? _entries;

  // lifecycle
  @override
  void initState() {
    super.initState();
    _getEntries();
  }

  Future<void> _getEntries() async {
    _repository.getEntries(_query, _value).then((entries) {
      setState(() {
        _entries = entries.entries;
      });
    });
  }

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
                await _getEntries();
              }
            },
          ),
          Visibility(
            visible: _query != null || _value != null,
            child: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () async {
                setState(() {
                  _query = null;
                  _value = null;
                });
                await _getEntries();
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: _entries?.length ?? 0,
          itemBuilder: (context, index) {
            return TimeEntryCard(
              entry: _entries![index],
              onDelete: () async {
                await _getEntries();
              },
              onEdit: () async {
                await _getEntries();
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EntryInputPage(),
            ),
          );
          await _getEntries();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
