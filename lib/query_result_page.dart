import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task_management_app/query_input_page.dart';
import 'package:task_management_app/entry_input_page.dart';
import 'package:task_management_app/time_entry.dart';
import 'package:task_management_app/time_entry_card.dart';

class QueryResultPage extends StatefulWidget {
  const QueryResultPage({super.key});

  @override
  State<QueryResultPage> createState() => _QueryResultPageState();
}

class _QueryResultPageState extends State<QueryResultPage> {
  // variables
  String? _query;
  String? _value;

  FirebaseFirestore? _db;
  List<TimeEntry>? _entries;

  // lifecycle
  @override
  void initState() {
    super.initState();
    _getEntries();
  }

  // modules
  Future<void> _initDB() async {
    _db = FirebaseFirestore.instance;
  }

  Future<void> _getEntries() async {
    if (_db == null) {
      await _initDB();
    }

    Query<Map<String, dynamic>> query;

    if (_query == null || _query!.isEmpty) {
      query = _db!.collection('entries');
    } else if (_query == 'date') {
      Timestamp date = Timestamp.fromDate(DateTime.parse(_value!));
      query = _db!.collection('entries').where(_query!, isEqualTo: date);
    } else {
      query = _db!.collection('entries').where(_query!, isEqualTo: _value);
    }

    await query.get().then((querySnapshot) {
      setState(() {
        _entries = querySnapshot.docs
            .map((doc) => TimeEntry.fromFirestore(doc, null))
            .toList();
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
            return TimeEntryCard(entry: _entries![index]);
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