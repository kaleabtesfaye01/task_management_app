import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_management_app/entry_input_page.dart';
import 'package:task_management_app/time_entry.dart';

class TimeEntryCard extends StatefulWidget {
  const TimeEntryCard({
    super.key,
    required this.entry,
    required this.onDelete,
    required this.onEdit,
  });

  final TimeEntry entry;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  @override
  State<TimeEntryCard> createState() => _TimeEntryCardState();
}

class _TimeEntryCardState extends State<TimeEntryCard> {
  FirebaseFirestore? _db;

  Future<void> _initDB() async {
    _db = FirebaseFirestore.instance;
  }

  Future<void> _deleteEntry() async {
    if (_db == null) {
      await _initDB();
    }

    await _db!.collection('entries').doc(widget.entry.id).delete();
    widget.onDelete();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Task: ${widget.entry.task}'),
          Text('Tag: ${widget.entry.tag}'),
          Text('Date: ${DateFormat.yMd().format(widget.entry.date)}'),
          Text('From: ${DateFormat.Hm().format(widget.entry.from)}'),
          Text('To: ${DateFormat.Hm().format(widget.entry.to)}'),
          Row(
            children: <Widget>[
              TextButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EntryInputPage(entry: widget.entry),
                    ),
                  );
                  widget.onEdit();
                },
                child: const Text('Edit'),
              ),
              TextButton(
                onPressed: () async {
                  await _deleteEntry();
                },
                child: const Text('Delete'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
