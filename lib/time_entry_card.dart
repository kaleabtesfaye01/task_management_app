import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_management_app/time_entry.dart';

class TimeEntryCard extends StatelessWidget {
  final TimeEntry entry;

  const TimeEntryCard({
    super.key,
    required this.entry,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Task: ${entry.task}'),
          Text('Tag: ${entry.tag}'),
          Text('Date: ${DateFormat.yMd().format(entry.date)}'),
          Text('From: ${DateFormat.Hm().format(entry.from)}'),
          Text('To: ${DateFormat.Hm().format(entry.to)}'),
          Row(
            children: <Widget>[
              TextButton(
                onPressed: () {},
                child: const Text('Edit'),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Delete'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
