import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_management_app/data/repository.dart';
import 'package:task_management_app/entry_input_page.dart';
import 'package:task_management_app/model/time_entry.dart';

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
  final _repository = Repository();

  Future<void> _deleteEntry() async {
    _repository.deleteEntry(widget.entry.id).then((response) {
      if (response.success) {
        widget.onDelete();
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error deleting entry'),
            ),
          );
        }
      }
    });
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
